import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/add_room_screen.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/room_card.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).rooms,
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        centerTitle: theme.appBarTheme.centerTitle,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocProvider.value(
        value: DashboardBloc.get()..add(GetRoomsEvent()),
        child: ConnectionWidget(
          onRetry: () => DashboardBloc.get().add(GetRoomsEvent()),
          child: BlocBuilder<DashboardBloc, DashboardState>(
            buildWhen: (previous, current) =>
                current is GetRoomsLoading ||
                current is GetRoomsError ||
                current is GetRoomsSuccess ||
                current is DeleteRoomSuccess ||
                current is AddRoomSuccess,
            builder: (context, state) => _buildBody(context, state, theme),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context, theme),
    );
  }

  Widget _buildBody(
      BuildContext context, DashboardState state, ThemeData theme) {
    if (state is GetRoomsLoading) {
      return const CustomLoadingWidget();
    }

    if (state is GetRoomsError) {
      return _buildErrorWidget(state, theme);
    }

    if (state is GetRoomsSuccess ||
        state is DeleteRoomSuccess ||
        state is AddRoomSuccess) {
      final rooms = state.rooms ?? [];

      if (rooms.isEmpty) {
        return Center(
          child: NoDataWidget(),
        );
      }

      return _buildRoomsList(context, rooms, theme);
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorWidget(GetRoomsError state, ThemeData theme) {
    return Center(
      child: SizedBox(
        width: 200.w,
        height: 120.h,
        child: CustomErrorWidget(exception: state.exception),
      ),
    );
  }

  Widget _buildRoomsList(BuildContext context, List rooms, ThemeData theme) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: rooms.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final room = rooms[index];
        return RoomCard(
          room: room,
          onDelete: () => _deleteRoom(context, room.id),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, ThemeData theme) {
    return FloatingActionButton(
      onPressed: () => _navigateToAddRoom(context),
      backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
      foregroundColor: theme.floatingActionButtonTheme.foregroundColor,
      elevation: theme.floatingActionButtonTheme.elevation,
      shape: theme.floatingActionButtonTheme.shape,
      child: Icon(
        Icons.add,
        size: 24.sp,
      ),
    );
  }

  void _deleteRoom(BuildContext context, String roomId) {
    context.read<DashboardBloc>().add(DeleteRoomEvent(roomId));
  }

  void _navigateToAddRoom(BuildContext context) {
    context.push(AddRoomScreen());
  }
}
