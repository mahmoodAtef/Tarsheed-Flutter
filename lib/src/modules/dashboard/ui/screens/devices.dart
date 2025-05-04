import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/bottom_navigator_bar.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/models/device.dart';
import '../../data/models/device_creation_form.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/card_devices.dart';
import '../widgets/device_search_bar.dart';
import '../widgets/edit_device_dialog.dart';
import '../widgets/filter_tabs_row.dart';
import 'device_creation_page.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  String? selectedDeviceIdForDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned.fill(child: BackGroundRectangle()),
              Column(
                children: [
                  const CustomAppBar(text: 'Devices'),
                  const SizedBox(height: 10),

                  /// Search Bar
                  const DeviceSearchBar(),
                  const SizedBox(height: 10),

                  /// Filter Tabs
                  const FilterTabsRow(),
                  const SizedBox(height: 10),

                  /// Devices List
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: BlocConsumer<DashboardBloc, DashboardState>(
                        listenWhen: (previous, current) =>
                            current is DeleteDeviceSuccess ||
                            current is DeleteDeviceError,
                        listener: (context, state) {
                          if (state is DeleteDeviceSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Device deleted successfully')),
                            );
                          } else if (state is DeleteDeviceError) {
                            ExceptionManager.showMessage(state.exception);
                          }
                        },
                        buildWhen: (previous, current) =>
                            current is DeviceState,
                        builder: (context, state) {
                          if (state is GetDevicesLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is GetDevicesError) {
                            ExceptionManager.showMessage(state.exception);
                          } else {
                            final devices =
                                context.read<DashboardBloc>().devices;
                            if (devices.isEmpty) {
                              return const Center(
                                  child: Text('No devices added.'));
                            }
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: devices.map((device) {
                                return GestureDetector(
                                  onLongPress: () {
                                    selectedDeviceIdForDelete = device.id;
                                    _showDeleteConfirmation(device.id);
                                  },
                                  child: DeviceCard(
                                    device: device,
                                    onToggle: (bool newState) {},
                                    onEdit: () {
                                      _showEditDialog(device);
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDevice = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DeviceCreationPage()),
          );
          if (newDevice != null && newDevice is DeviceCreationForm) {
            context.read<DashboardBloc>().add(AddDeviceEvent(newDevice));
          }
        },
        backgroundColor: ColorManager.primary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigator(),
    );
  }

  void _showEditDialog(Device device) {
    showDialog(
      context: context,
      builder: (context) => EditDeviceDialog(device: device),
    );
  }

  void _showDeleteConfirmation(String deviceId) {
    showDialog(
      context: context,
      builder: (_) => DeleteDeviceDialog(deviceId: deviceId),
    );
  }
}
