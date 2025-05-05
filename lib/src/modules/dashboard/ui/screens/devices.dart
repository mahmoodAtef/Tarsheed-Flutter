import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';

import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../data/models/device.dart';
import '../../data/models/device_creation_form.dart';
import '../widgets/card_devices.dart';
import '../widgets/delete_confirmation_dialog.dart';
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
      appBar: const CustomAppBar(text: 'Devices'),
      backgroundColor: ColorManager.white,
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: SafeArea(
            child: Stack(
              children: [
                const Positioned.fill(child: BackGroundRectangle()),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    const DeviceSearchBar(),
                    const SizedBox(height: 10),

                    /// Filter Tabs
                    const FilterTabsRow(),
                    const SizedBox(height: 10),

                    /// Devices List
                    Padding(
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
                            return Center(
                              child: SizedBox(
                                height: 120.h,
                                child: CustomLoadingWidget(),
                              ),
                            );
                          } else if (state is GetDevicesError) {
                            return Center(
                              child: CustomErrorWidget(
                                message: ExceptionManager.getMessage(
                                    state.exception),
                              ),
                            );
                          } else {
                            final devices =
                                context.read<DashboardBloc>().devices;
                            if (devices.isEmpty) {
                              return Center(
                                child: SizedBox(
                                  height: 120.h,
                                  child: NoDataWidget(),
                                ),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.all(8.w),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: devices.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10.h,
                                    crossAxisSpacing: 10.w,
                                  ),
                                  itemBuilder: (context, index) {
                                    final device = devices[index];
                                    return DeviceCard(
                                      onToggle: (value) {},
                                      device: device,
                                      onEdit: () => _showEditDialog(device),
                                      onDelete: () {
                                        selectedDeviceIdForDelete = device.id;
                                        _showDeleteConfirmation(device.id);
                                      },
                                    );
                                  }),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
