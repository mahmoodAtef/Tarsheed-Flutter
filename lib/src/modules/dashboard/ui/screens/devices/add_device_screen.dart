import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/core/widgets/large_button.dart';
import 'package:tarsheed/src/core/widgets/text_field.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/category.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/device_creation_form.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pinNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedRoomId;
  String? selectedCategoryId;
  String? selectedDevicePriority;
  List<DeviceCategory> categories = [];
  List<Room> rooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(S.of(context).addDevice),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: DevicesCubit.get(),
          ),
          BlocProvider.value(
            value: DashboardBloc.get()
              ..add(GetRoomsEvent())
              ..add(GetDevicesCategoriesEvent()),
          ),
        ],
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    hintText: S.of(context).name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).nameRequired;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    controller: _descriptionController,
                    hintText: S.of(context).description,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).descriptionRequired;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    controller: _pinNumberController,
                    hintText: S.of(context).pinNumber,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pinNumberRequired;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),
                  BlocConsumer<DashboardBloc, DashboardState>(
                    listener: (context, state) {
                      if (state is GetRoomsSuccess) {
                        rooms = state.rooms ?? [];
                      } else if (state is GetRoomsError) {
                        ExceptionManager.showMessage(state.exception);
                      }
                    },
                    builder: (context, state) {
                      return DropDownWidget(
                        label: S.of(context).room,
                        items: rooms.isEmpty
                            ? [DropDownItem(S.of(context).noRoomsAvailable, "")]
                            : rooms
                                .map((room) => DropDownItem(room.id, room.name))
                                .toList(),
                        onChanged: (value) {
                          selectedRoomId = value;
                          return null;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).roomRequired;
                          }
                          return null;
                        },
                        value: selectedRoomId,
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  BlocConsumer<DashboardBloc, DashboardState>(
                    listener: (context, state) {
                      if (state is GetDeviceCategoriesSuccess) {
                        categories = state.deviceCategories;
                      } else if (state is GetDeviceCategoriesError) {
                        ExceptionManager.showMessage(state.exception);
                      }
                      if (state is GetRoomsSuccess) {
                        rooms = state.rooms ?? [];
                      } else if (state is GetRoomsError) {
                        ExceptionManager.showMessage(state.exception);
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, state) {
                          return DropDownWidget(
                            label: S.of(context).category,
                            items: categories.isEmpty
                                ? [
                                    DropDownItem(
                                        S.of(context).noCategoriesAvailable, "")
                                  ]
                                : categories
                                    .map((category) => DropDownItem(
                                        category.id, category.name))
                                    .toList(),
                            onChanged: (value) {
                              selectedCategoryId = value;
                              return null;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).categoryRequired;
                              }
                              return null;
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  DropDownWidget(
                    label: S.of(context).priority,
                    items: [
                      DropDownItem("1", S.of(context).veryHigh,
                          leading: Icon(Icons.warning, color: Colors.red)),
                      DropDownItem("2", S.of(context).high,
                          leading: Icon(Icons.info, color: Colors.orange)),
                      DropDownItem("3", S.of(context).medium,
                          leading:
                              Icon(Icons.info_outline, color: Colors.blue)),
                      DropDownItem("4", S.of(context).low,
                          leading:
                              Icon(Icons.low_priority, color: Colors.grey)),
                    ],
                    onChanged: (value) {
                      selectedDevicePriority = value;
                      return null;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).priorityRequired;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: BlocConsumer<DevicesCubit, DevicesState>(
                      listenWhen: (previous, current) =>
                          current is AddDeviceSuccess ||
                          current is AddDeviceError,
                      listener: (context, state) {
                        if (state is AddDeviceSuccess) {
                          showToast(S.of(context).deviceAddedSuccessfully);
                          context.pop();
                        } else if (state is AddDeviceError) {
                          ExceptionManager.showMessage(state.exception);
                        }
                      },
                      builder: (context, state) {
                        return DefaultButton(
                          title: S.of(context).addDevice,
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final form = DeviceCreationForm(
                                name: _nameController.text,
                                description: _descriptionController.text,
                                pinNumber: _pinNumberController.text,
                                roomId: selectedRoomId!,
                                categoryId: selectedCategoryId!,
                                priority: int.parse(selectedDevicePriority!),
                              );

                              DevicesCubit.get().addDevice(form);
                            }
                          },
                          isLoading: state is AddDeviceLoading,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
