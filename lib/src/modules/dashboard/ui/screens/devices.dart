import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/bottomNavigatorBar.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/models/device_creation_form.dart';
import '../widgets/card_devices.dart';
import '../../../../core/widgets/rectangle_background.dart';
import 'deviceFormPage.dart';
import 'device_creation_Page.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rooms')),
    );
  }
}

class PriorityPage extends StatelessWidget {
  const PriorityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
    );
  }
}

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final List<DeviceCreationForm> devices = [];

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: Colors.grey.shade600, size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: TextField(
                              autofocus: false,
                              decoration: InputDecoration(
                                hintText: 'Search devices..',
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.grid_view, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      children: [
                        FilterTab(label: 'Consumption', isActive: true, onTap: () {}),
                        const SizedBox(width: 10),
                        FilterTab(
                          label: 'Rooms',
                          isActive: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RoomsPage()),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        FilterTab(
                          label: 'Priority',
                          isActive: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PriorityPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: BlocBuilder<DashboardBloc, DashboardState>(
                        buildWhen: (previous, current) => current is DeviceState,
                        builder: (context, state) {
                          if (state is GetDevicesLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is GetDevicesSuccess) {
                            final devices = state.devices;
                            if (devices.isEmpty) {
                              return const Center(child: Text('No devices added.'));
                            }
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: devices.map((device) {
                                return DeviceCard(
                                  device: device,
                                  onToggle: (bool newState) {
                                  },
                                  onEdit: () {
                                  },
                                );
                              }).toList(),
                            );
                          } else if (state is GetDevicesError) {
                            ExceptionManager.showMessage(state.exception);
                          }
                          return const SizedBox.shrink();
                        },
                      )

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
            setState(() {
              devices.add(newDevice);
            });
            context.read<DashboardBloc>().add(AddDeviceEvent(newDevice));
          }
        },
        backgroundColor: ColorManager.primary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavigator(currentIndex: -1),
    );
  }
}

class FilterTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FilterTab({
    Key? key,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? ColorManager.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
