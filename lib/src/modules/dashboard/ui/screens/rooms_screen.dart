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
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).rooms),
      ),
      body: BlocProvider.value(
        value: DashboardBloc.get()..add(GetRoomsEvent()),
        child: ConnectionWidget(
          onRetry: () {
            DashboardBloc.get().add(GetRoomsEvent());
          },
          child: BlocBuilder<DashboardBloc, DashboardState>(
            buildWhen: (previous, current) =>
                current is GetRoomsLoading ||
                current is GetRoomsError ||
                current is GetRoomsSuccess ||
                current is DeleteRoomSuccess ||
                current is AddRoomSuccess,
            builder: (context, state) {
              if (state is GetRoomsLoading) {
                return const CustomLoadingWidget();
              } else if (state is GetRoomsError) {
                return Center(
                  child: SizedBox(
                      width: 200.w,
                      height: 120.h,
                      child: CustomErrorWidget(exception: state.exception)),
                );
              } else if (state is GetRoomsSuccess ||
                  state is DeleteRoomSuccess ||
                  state is AddRoomSuccess) {
                // استخدم الـ rooms من الـ state الحالي
                final rooms = state.rooms ?? [];

                if (rooms.isEmpty) {
                  return Center(child: const NoDataWidget());
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: rooms.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return RoomCard(
                      room: room,
                      onDelete: () {
                        context.read<DashboardBloc>().add(DeleteRoomEvent(
                              room.id,
                            ));
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddRoom(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddRoom(BuildContext context) {
    context.push(AddRoomScreen());
  }
}
