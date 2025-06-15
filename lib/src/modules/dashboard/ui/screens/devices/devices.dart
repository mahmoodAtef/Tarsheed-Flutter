import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
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
      _devicesCubit.getDevices();
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
    return Scaffold(
      backgroundColor: ColorManager.white,
      extendBody: true,
      body: RefreshIndicator(
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
                  CustomAppBar(text: 'Devices'),
                  DeviceFilterHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: BlocProvider(
                      create: (context) => DashboardBloc.get(),
                      child: DevicesListView(),
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
          context.push(AddDeviceScreen());
        },
        backgroundColor: ColorManager.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DeviceFilterHeader extends StatelessWidget {
  const DeviceFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DevicesCubit, DevicesState, Map<String, dynamic>>(
      selector: (state) => {
        'filterType': state.filterType,
        'sortOrder': state.sortOrder,
      },
      builder: (context, data) {
        final filterType = data['filterType'] as DeviceFilterType;
        final sortOrder = data['sortOrder'] as SortOrder;

        return Row(
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
            IconButton(
              onPressed: () {
                DevicesCubit.get().toggleSortOrder();
              },
              icon: Icon(
                sortOrder == SortOrder.ascending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: ColorManager.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class DevicesListView extends StatelessWidget {
  const DevicesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const SnackBar(content: Text('Device deleted successfully')),
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
                child: CustomLoadingWidget(),
              );
            }

            if (state is GetDevicesError && state.devices == null) {
              return CustomErrorWidget(
                exception: state.exception,
              );
            }

            final devices = state.devices;
            if (devices == null || devices.isEmpty) {
              return NoDataWidget();
            }

            final filteredData = DevicesCubit.get().getFilteredDevices(rooms);

            if (state.filterType == DeviceFilterType.rooms) {
              final devicesByRoom = filteredData as Map<String, List<Device>>;
              return _buildRoomsView(devicesByRoom, context, rooms);
            } else {
              final devicesList = filteredData as List<Device>;
              return _buildGridView(devicesList);
            }
          },
        );
      },
    );
  }

  Widget _buildGridView(List<Device> devices) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
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
    return ListView.builder(
      itemCount: devicesByRoom.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final roomId = devicesByRoom.keys.toList()[index];
        final roomDevices = devicesByRoom[roomId]!;
        final roomName = _getRoomName(roomId, rooms);
        return Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roomName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              _buildGridView(roomDevices),
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
