import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

import '../../../../../core/error/exception_manager.dart';
import '../../../../../core/widgets/appbar.dart';
import '../../../../../core/widgets/rectangle_background.dart';
import '../../../data/models/device.dart';
import '../../../data/models/room.dart';
import '../../widgets/devices/card_devices.dart';
import '../../widgets/devices/devices_filter_tabs.dart';
import 'add_device_screen.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  late final DevicesCubit _devicesCubit;

  @override
  void initState() {
    super.initState();
    _devicesCubit = DevicesCubit.get();

    // Only fetch devices if they haven't been loaded yet
    if (_devicesCubit.state is DevicesInitial) {
      _devicesCubit.getDevices(refresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _devicesCubit,
      child: const _DevicesScreenContent(),
    );
  }
}

class _DevicesScreenContent extends StatelessWidget {
  const _DevicesScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        onRefresh: () async {
          DevicesCubit.get().getDevices(refresh: true);
        },
        child: Stack(
          children: [
            const Positioned.fill(child: BackGroundRectangle()),
            SingleChildScrollView(
              child: Column(
                spacing: 20.h,
                children: [
                  CustomAppBar(text: S.of(context).devices),
                  const DeviceFilterHeader(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                    child: BlocProvider.value(
                      value: DashboardBloc.get(),
                      child: const DevicesListView(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(BlocProvider.value(
            value: DevicesCubit.get(),
            child: const AddDeviceScreen(),
          ));
        },
        backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
        foregroundColor: theme.floatingActionButtonTheme.foregroundColor,
        elevation: theme.floatingActionButtonTheme.elevation,
        child: Icon(
          Icons.add,
          size: 24.sp,
        ),
      ),
    );
  }
}

class DeviceFilterHeader extends StatelessWidget {
  const DeviceFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<DevicesCubit, DevicesState, Map<String, dynamic>>(
      selector: (state) => {
        'filterType': state.filterType,
        'sortOrder': state.sortOrder,
      },
      builder: (context, data) {
        final filterType = data['filterType'] as DeviceFilterType;
        final sortOrder = data['sortOrder'] as SortOrder;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: Row(
            children: [
              Expanded(
                child: FilterTabsRow(
                  selectedTabIndex: filterType.index,
                  onTabSelected: (index) {
                    DevicesCubit.get()
                        .updateFilterType(DeviceFilterType.values[index]);
                  },
                ),
              ),
              // Sort Order Toggle Button
              Container(
                margin: EdgeInsets.only(left: 8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 4.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    DevicesCubit.get().toggleSortOrder();
                  },
                  tooltip: sortOrder == SortOrder.ascending
                      ? S.of(context).sortAscending
                      : S.of(context).sortDescending,
                  icon: Icon(
                    sortOrder == SortOrder.ascending
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: theme.colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DevicesListView extends StatelessWidget {
  const DevicesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Room> rooms = [];

    return BlocConsumer<DashboardBloc, DashboardState>(
      listenWhen: (previous, current) =>
          current is GetRoomsSuccess || current is GetRoomsError,
      buildWhen: (previous, current) =>
          current is GetRoomsSuccess || current is GetRoomsError,
      listener: (context, state) {
        if (state is GetRoomsSuccess) {
          rooms = state.rooms ?? [];
        } else if (state is GetRoomsError) {
          ExceptionManager.showMessage(state.exception);
        }
      },
      builder: (context, state) {
        return BlocConsumer<DevicesCubit, DevicesState>(
          listenWhen: (previous, current) =>
              current is DeleteDeviceSuccess || current is DeleteDeviceError,
          listener: (context, state) {
            if (state is DeleteDeviceSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    S.of(context).deviceDeletedSuccessfully,
                    style: theme.snackBarTheme.contentTextStyle,
                  ),
                  backgroundColor: theme.snackBarTheme.backgroundColor,
                  behavior: theme.snackBarTheme.behavior,
                  shape: theme.snackBarTheme.shape,
                ),
              );
            } else if (state is DeleteDeviceError) {
              ExceptionManager.showMessage(state.exception);
            }
          },
          buildWhen: (previous, current) {
            // Rebuild when device list changes, filter changes, or any device status changes
            return previous.devices != current.devices ||
                previous.filterType != current.filterType ||
                previous.sortOrder != current.sortOrder ||
                current is ToggleDeviceStatusLoading ||
                current is ToggleDeviceStatusSuccess ||
                current is ToggleDeviceStatusError ||
                (current is GetDevicesLoading && current.refresh == true) ||
                (current is GetDevicesLoading &&
                    previous is! GetDevicesLoading) ||
                (previous is GetDevicesLoading &&
                    current is! GetDevicesLoading);
          },
          builder: (context, state) {
            // Show loading indicator only for initial load or refresh
            if (state is GetDevicesLoading &&
                (state.devices == null || state.refresh == true)) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: const CustomLoadingWidget(),
                ),
              );
            }

            if (state is GetDevicesError && state.devices == null) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: CustomErrorWidget(
                  exception: state.exception,
                ),
              );
            }

            final devices = state.devices;
            if (devices == null || devices.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: const NoDataWidget(),
              );
            }

            final filteredData = DevicesCubit.get().getFilteredDevices(rooms);

            if (state.filterType == DeviceFilterType.rooms) {
              final devicesByRoom = filteredData as Map<String, List<Device>>;
              return _buildRoomsView(devicesByRoom, context, rooms);
            } else {
              final devicesList = filteredData as List<Device>;
              return _buildGridView(devicesList, context);
            }
          },
        );
      },
    );
  }

  Widget _buildGridView(List<Device> devices, BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0.h,
        crossAxisSpacing: 8.0.w,
        childAspectRatio: 1.0,
      ),
      itemCount: devices.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final device = devices[index];
        return Padding(
          padding: EdgeInsets.all(5.w),
          child: DeviceCard(
            device: device,
          ),
        );
      },
    );
  }

  Widget _buildRoomsView(Map<String, List<Device>> devicesByRoom,
      BuildContext context, List<Room> rooms) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: devicesByRoom.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final roomId = devicesByRoom.keys.toList()[index];
        final roomDevices = devicesByRoom[roomId]!;
        final roomName = _getRoomName(roomId, rooms);

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 5.w,
            vertical: 8.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.room,
                      color: theme.colorScheme.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      roomName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${roomDevices.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildGridView(roomDevices, context),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  String _getRoomName(String roomId, List<Room> rooms) {
    final room = rooms.firstWhere(
      (room) => room.id == roomId,
      orElse: () => Room.empty,
    );
    return room.name;
  }
}
