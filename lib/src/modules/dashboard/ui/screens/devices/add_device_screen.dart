import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/theme_manager.dart';
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
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pinNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          S.of(context).addDevice,
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        centerTitle: theme.appBarTheme.centerTitle,
        surfaceTintColor: theme.appBarTheme.surfaceTintColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.appBarTheme.iconTheme?.color,
            size: theme.appBarTheme.iconTheme?.size ?? 24.sp,
          ),
        ),
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
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device Name Section
                  _buildSectionHeader(
                    context,
                    S.of(context).deviceName,
                    Icons.devices,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _nameController,
                    hintText: S.of(context).enterDeviceName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).nameRequired;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 24.h),

                  // Device Description Section
                  _buildSectionHeader(
                    context,
                    S.of(context).deviceDescription,
                    Icons.description,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _descriptionController,
                    hintText: S.of(context).enterDeviceDescription,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).descriptionRequired;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                  ),
                  SizedBox(height: 24.h),

                  // Pin Number Section
                  _buildSectionHeader(
                    context,
                    S.of(context).pinNumber,
                    Icons.pin,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _pinNumberController,
                    hintText: S.of(context).enterPinNumber,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pinNumberRequired;
                      }
                      if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return S.of(context).pinNumberMustBeNumeric;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24.h),

                  // Room Selection Section
                  _buildSectionHeader(
                    context,
                    S.of(context).selectRoom,
                    Icons.room,
                  ),
                  SizedBox(height: 8.h),
                  BlocConsumer<DashboardBloc, DashboardState>(
                    listener: (context, state) {
                      if (state is GetRoomsSuccess) {
                        rooms = state.rooms ?? [];
                      } else if (state is GetRoomsError) {
                        ExceptionManager.showMessage(state.exception);
                      }
                    },
                    builder: (context, state) {
                      return _buildDropdownCard(
                        child: DropDownWidget(
                          label: S.of(context).room,
                          items: rooms.isEmpty
                              ? [
                                  DropDownItem(
                                      S.of(context).noRoomsAvailable, "")
                                ]
                              : rooms
                                  .map((room) =>
                                      DropDownItem(room.id, room.name))
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
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Category Selection Section
                  _buildSectionHeader(
                    context,
                    S.of(context).selectCategory,
                    Icons.category,
                  ),
                  SizedBox(height: 8.h),
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
                          return _buildDropdownCard(
                            child: DropDownWidget(
                              label: S.of(context).category,
                              items: categories.isEmpty
                                  ? [
                                      DropDownItem(
                                          S.of(context).noCategoriesAvailable,
                                          "")
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
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Priority Selection Section
                  _buildSectionHeader(
                    context,
                    S.of(context).selectPriority,
                    Icons.priority_high,
                  ),
                  SizedBox(height: 8.h),
                  _buildDropdownCard(
                    child: DropDownWidget(
                      label: S.of(context).priority,
                      items: [
                        DropDownItem(
                          "1",
                          S.of(context).veryHigh,
                          leading: Icon(
                            Icons.warning,
                            color: ThemeManager.dangerRed,
                            size: 20.sp,
                          ),
                        ),
                        DropDownItem(
                          "2",
                          S.of(context).high,
                          leading: Icon(
                            Icons.info,
                            color: ThemeManager.warningOrange,
                            size: 20.sp,
                          ),
                        ),
                        DropDownItem(
                          "3",
                          S.of(context).medium,
                          leading: Icon(
                            Icons.info_outline,
                            color: ThemeManager.primaryBlue,
                            size: 20.sp,
                          ),
                        ),
                        DropDownItem(
                          "4",
                          S.of(context).low,
                          leading: Icon(
                            Icons.low_priority,
                            color: ThemeManager.iconGray,
                            size: 20.sp,
                          ),
                        ),
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
                  ),
                  SizedBox(height: 32.h),

                  // Add Device Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: BlocConsumer<DevicesCubit, DevicesState>(
                      listenWhen: (previous, current) =>
                          current is AddDeviceSuccess ||
                          current is AddDeviceError,
                      listener: (context, state) {
                        if (state is AddDeviceSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                S.of(context).deviceAddedSuccessfully,
                                style: theme.snackBarTheme.contentTextStyle,
                              ),
                              backgroundColor: ThemeManager.successGreen,
                              behavior: theme.snackBarTheme.behavior,
                              shape: theme.snackBarTheme.shape,
                              duration: const Duration(seconds: 3),
                            ),
                          );
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
                                name: _nameController.text.trim(),
                                description: _descriptionController.text.trim(),
                                pinNumber: _pinNumberController.text.trim(),
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
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownCard({required Widget child}) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.5),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: child,
    );
  }
}
