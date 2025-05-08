import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../data/models/device.dart';
import '../../data/models/device_creation_form.dart';
import '../../data/models/room.dart';
import '../widgets/card_devices.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/device_search_bar.dart';
import '../widgets/devices_filter_tabs.dart';
import '../widgets/edit_device_dialog.dart';
import 'device_creation_page.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DevicesCubit>.value(
      value: sl<DevicesCubit>()..getDevices(),
      child: _DevicesScreenContent(),
    );
  }

  _refresh() {
    return BlocProvider<DevicesCubit>.value(
      value: sl<DevicesCubit>()..getDevices(refresh: true),
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
      context.read<DevicesCubit>().addDevice(newDevice);
    }
  }
}

class DeviceFilterHeader extends StatelessWidget {
  const DeviceFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesCubit, DevicesState>(
      buildWhen: (previous, current) =>
          previous.filterType != current.filterType ||
          previous.sortOrder != current.sortOrder,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: FilterTabsRow(
                selectedTabIndex: state.filterType.index,
                onTabSelected: (index) {
                  context
                      .read<DevicesCubit>()
                      .updateFilterType(DeviceFilterType.values[index]);
                },
              ),
            ),
            // Sort Order Toggle Button
            IconButton(
              onPressed: () {
                context.read<DevicesCubit>().toggleSortOrder();
              },
              icon: Icon(
                state.sortOrder == SortOrder.ascending
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
    final List<Room> rooms = sl<DashboardBloc>().rooms;

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
      builder: (context, state) {
        if (state is GetDevicesLoading) {
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

        final devices = state.devices;

        if (devices == null || devices.isEmpty) {
          return const NoDataWidget();
        }

        final filteredData =
            context.read<DevicesCubit>().getFilteredDevices(rooms);

        if (state.filterType == DeviceFilterType.rooms) {
          return _buildRoomsView(filteredData, context, rooms);
        } else {
          return _buildGridView(filteredData, context);
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

  Widget _buildRoomsView(Map<String, List<Device>> devicesByRoom,
      BuildContext context, List<Room> rooms) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: devicesByRoom.length,
      itemBuilder: (context, index) {
        final roomId = devicesByRoom.keys.elementAt(index);
        final roomDevices = devicesByRoom[roomId]!;
        final roomName = _getRoomName(roomId, rooms);

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
    super.key,
    required this.device,
  });

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
