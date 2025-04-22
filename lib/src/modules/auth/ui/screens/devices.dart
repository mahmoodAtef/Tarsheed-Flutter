import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import '../../../../core/error/exception_manager.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/card_devices.dart';
import '../widgets/device_model_adding.dart';
import '../widgets/rectangle_background.dart';
import 'deviceFormPage.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc()..add(GetRoomsEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Rooms')),
        body: BlocListener<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state is GetRoomsError) {
              ExceptionManager.showMessage(state.exception);
            }
          },
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is GetRoomsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetRoomsSuccess) {
                return ListView.builder(
                  itemCount: state.rooms.length,
                  itemBuilder: (context, index) {
                    var room = state.rooms[index];
                    return ListTile(
                      title: Text(room.name ?? 'No Name'),
                      subtitle: Text('ID: ${room.id}'),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No rooms found.'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class PriorityPage extends StatelessWidget {
  const PriorityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc()..add(GetDevicesCategoriesEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Priority')),
        body: BlocListener<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state is GetDeviceCategoriesError) {
              ExceptionManager.showMessage(state.exception);
            }
          },
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is GetDeviceCategoriesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetDeviceCategoriesSuccess) {
                return ListView.builder(
                  itemCount: state.deviceCategories.length,
                  itemBuilder: (context, index) {
                    var category = state.deviceCategories[index];
                    return ListTile(
                      title: Text(category.name ?? 'No Name'),
                      subtitle: Text('ID: ${category.id}'),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No categories found.'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final List<DeviceModel> devices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned.fill(
                child: BackGroundRectangle(),
              ),
              Column(
                children: [
                  const CustomAppBar(text: 'Devices'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 18,
                          margin: const EdgeInsets.all(1),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SizedBox(width: 22),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              autofocus: false,
                              showCursor: true,
                              decoration: const InputDecoration(
                                hintText: 'Search devices..',
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: const TextStyle(fontSize: 14),
                              keyboardAppearance: Brightness.light,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.grid_view, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                              MaterialPageRoute(builder: (context) => const RoomsPage()),
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
                              MaterialPageRoute(builder: (context) => const PriorityPage()),
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
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: devices.map((device) {
                          return DeviceCard(
                            icon: device.icon,
                            deviceName: device.name,
                            deviceType: device.type,
                            isActive: device.isActive,
                            onToggle: (value) {
                              setState(() {
                                device.isActive = value;
                              });
                            },
                            onEdit: () async {
                              final editedDevice = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DeviceFormPage(initialDevice: device),
                                ),
                              );
                              if (editedDevice != null && editedDevice is DeviceModel) {
                                setState(() {
                                  final index = devices.indexOf(device);
                                  devices[index] = editedDevice;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDevice = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DeviceFormPage()),
          );
          if (newDevice != null && newDevice is DeviceModel) {
            setState(() {
              devices.add(newDevice);
            });
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
