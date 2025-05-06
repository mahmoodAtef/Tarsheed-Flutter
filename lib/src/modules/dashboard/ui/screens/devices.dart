import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/models/device.dart';
import '../../data/models/device_creation_form.dart';
import '../widgets/card_devices.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/device_search_bar.dart';
import '../widgets/devices_filter_tabs.dart';
import '../widgets/edit_device_dialog.dart';
import 'device_creation_page.dart';

enum DeviceFilterType { consumption, rooms, priority }

enum SortOrder { ascending, descending }

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DevicesFilterCubit>(
      create: (_) => DevicesFilterCubit(),
      child: _DevicesScreenContent(),
    );
  }
}

class _DevicesScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Stack(
          children: [
            const Positioned.fill(child: BackGroundRectangle()),
            SingleChildScrollView(
              child: Column(
                children: [
                  const CustomAppBar(text: 'Devices'),
                  const SizedBox(height: 10),
                  const DeviceSearchBar(),
                  const SizedBox(height: 10),
                  const DeviceFilterHeader(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: DevicesListView(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddDevice(context),
        backgroundColor: ColorManager.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddDevice(BuildContext context) async {
    final newDevice = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DeviceCreationPage()),
    );

    if (newDevice != null && newDevice is DeviceCreationForm) {
      context.read<DashboardBloc>().add(AddDeviceEvent(newDevice));
    }
  }
}

class DeviceFilterHeader extends StatelessWidget {
  const DeviceFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesFilterCubit, DevicesFilterState>(
      builder: (context, filterState) {
        return Row(
          children: [
            Expanded(
              child: FilterTabsRow(
                selectedTabIndex: filterState.filterType.index,
                onTabSelected: (index) {
                  context
                      .read<DevicesFilterCubit>()
                      .updateFilterType(DeviceFilterType.values[index]);
                },
              ),
            ),
            // Sort Order Toggle Button
            IconButton(
              onPressed: () {
                context.read<DevicesFilterCubit>().toggleSortOrder();
              },
              icon: Icon(
                filterState.sortOrder == SortOrder.ascending
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
    return BlocConsumer<DashboardBloc, DashboardState>(
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
      builder: (context, state) {
        if (state is GetDevicesLoading ||
            state is AddDeviceLoading ||
            state is EditDeviceLoading ||
            state is DeleteDeviceLoading) {
          return Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0.h),
            child: CustomLoadingWidget(),
          ));
        }

        if (state is GetDevicesError) {
          return CustomErrorWidget(
            message: ExceptionManager.getMessage(state.exception),
          );
        }

        final devices = context.read<DashboardBloc>().devices;

        if (devices.isEmpty) {
          return const NoDataWidget();
        }

        final filterState = context.watch<DevicesFilterCubit>().state;

        final filteredDevices = _getFilteredDevices(
          devices,
          filterState.filterType,
          filterState.sortOrder,
          context.read<DashboardBloc>().rooms,
        );

        if (filterState.filterType == DeviceFilterType.rooms) {
          return _buildRoomsView(filteredDevices, context);
        } else {
          return _buildGridView(filteredDevices, context);
        }
      },
    );
  }

  Widget _buildGridView(List<Device> devices, BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: devices.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(5.w),
          child: DeviceCardWrapper(device: devices[index]),
        );
      },
    );
  }

  Widget _buildRoomsView(
      Map<String, List<Device>> devicesByRoom, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: devicesByRoom.length,
      itemBuilder: (context, index) {
        final roomId = devicesByRoom.keys.elementAt(index);
        final roomDevices = devicesByRoom[roomId]!;
        final roomName =
            _getRoomName(roomId, context.read<DashboardBloc>().rooms);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                roomName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
            ),
            _buildGridView(roomDevices, context),
            const Divider(thickness: 1),
          ],
        );
      },
    );
  }

  dynamic _getFilteredDevices(
    List<Device> devices,
    DeviceFilterType filterType,
    SortOrder sortOrder,
    List<Room> rooms,
  ) {
    switch (filterType) {
      case DeviceFilterType.consumption:
        final sortedDevices = List<Device>.from(devices);
        sortedDevices.sort((a, b) {
          final comparison = a.consumption.compareTo(b.consumption);
          return sortOrder == SortOrder.ascending ? comparison : -comparison;
        });
        return sortedDevices;

      case DeviceFilterType.rooms:
        final devicesByRoom = <String, List<Device>>{};

        for (final device in devices) {
          if (!devicesByRoom.containsKey(device.roomId)) {
            devicesByRoom[device.roomId] = [];
          }
          devicesByRoom[device.roomId]!.add(device);
        }

        // Sort devices within each room if needed
        devicesByRoom.forEach((roomId, roomDevices) {
          roomDevices.sort((a, b) {
            final comparison = a.name.compareTo(b.name);
            return sortOrder == SortOrder.ascending ? comparison : -comparison;
          });
        });

        return devicesByRoom;

      case DeviceFilterType.priority:
        final sortedDevices = List<Device>.from(devices);
        sortedDevices.sort((a, b) {
          final comparison = a.priority.compareTo(b.priority);
          return sortOrder == SortOrder.ascending ? comparison : -comparison;
        });
        return sortedDevices;
    }
  }

  String _getRoomName(String roomId, List<Room> rooms) {
    final room = rooms.firstWhere(
      (room) => room.id == roomId,
      orElse: () => Room.empty,
    );
    return room.name;
  }
}

class DeviceCardWrapper extends StatelessWidget {
  final Device device;

  const DeviceCardWrapper({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showDeleteConfirmation(context, device.id),
      child: DeviceCard(
        device: device,
        onToggle: (bool newState) {
          // Handle toggle action
        },
        onEdit: () => _showEditDialog(context, device),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (context) => EditDeviceDialog(device: device),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String deviceId) {
    showDialog(
      context: context,
      builder: (_) => DeleteDeviceDialog(deviceId: deviceId),
    );
  }
}

class DevicesFilterCubit extends Cubit<DevicesFilterState> {
  DevicesFilterCubit() : super(DevicesFilterState.initial());

  void updateFilterType(DeviceFilterType filterType) {
    emit(state.copyWith(filterType: filterType));
  }

  void toggleSortOrder() {
    final newOrder = state.sortOrder == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;
    emit(state.copyWith(sortOrder: newOrder));
  }
}

class DevicesFilterState {
  final DeviceFilterType filterType;
  final SortOrder sortOrder;

  DevicesFilterState({
    required this.filterType,
    required this.sortOrder,
  });

  factory DevicesFilterState.initial() {
    return DevicesFilterState(
      filterType: DeviceFilterType.consumption,
      sortOrder: SortOrder.descending,
    );
  }

  DevicesFilterState copyWith({
    DeviceFilterType? filterType,
    SortOrder? sortOrder,
  }) {
    return DevicesFilterState(
      filterType: filterType ?? this.filterType,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
