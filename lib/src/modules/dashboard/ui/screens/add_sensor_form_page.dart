import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/core/widgets/large_button.dart';
import 'package:tarsheed/src/core/widgets/text_field.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor_category.dart';

import '../../bloc/dashboard_bloc.dart';

class AddSensorFormPage extends StatefulWidget {
  const AddSensorFormPage({super.key});

  @override
  State<AddSensorFormPage> createState() => _AddSensorFormPageState();
}

class _AddSensorFormPageState extends State<AddSensorFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pinNumberController = TextEditingController();
  String? selectedPin;
  String? selectedRoomId;
  List<Room> rooms = [];
  SensorCategory? selectedSensorType;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = LocalizationManager.currentLocaleIndex == 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).addSensor,
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        centerTitle: theme.appBarTheme.centerTitle,
        iconTheme: theme.appBarTheme.iconTheme,
        surfaceTintColor: theme.appBarTheme.surfaceTintColor,
      ),
      body: BlocProvider.value(
        value: DashboardBloc.get()..add(GetRoomsEvent()),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildNameField(theme),
                  SizedBox(height: 12.h),
                  _buildDescriptionField(theme),
                  SizedBox(height: 12.h),
                  _buildPinNumberField(theme),
                  SizedBox(height: 12.h),
                  _buildRoomDropdown(theme),
                  SizedBox(height: 12.h),
                  _buildSensorTypeDropdown(theme, isArabic),
                  SizedBox(height: 100.h),
                  _buildSaveButton(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(ThemeData theme) {
    return CustomTextField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).nameRequired;
        }
        return null;
      },
      controller: nameController,
      hintText: S.of(context).sensorName,
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return CustomTextField(
      controller: descriptionController,
      hintText: S.of(context).description,
    );
  }

  Widget _buildPinNumberField(ThemeData theme) {
    return CustomTextField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).pinNumberRequired;
        }
        return null;
      },
      controller: pinNumberController,
      hintText: S.of(context).pinNumber,
    );
  }

  Widget _buildRoomDropdown(ThemeData theme) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is RoomState) {
          rooms = state.rooms ?? [];
          if (rooms.isNotEmpty && selectedRoomId == null) {
            selectedRoomId = rooms.first.id;
          }
        } else if (state is GetRoomsError) {
          ExceptionManager.showMessage(state.exception);
        }
      },
      buildWhen: (current, previous) => current is RoomState,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 1.w,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedRoomId,
            hint: Text(
              S.of(context).room,
              style: theme.inputDecorationTheme.hintStyle,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            dropdownColor: theme.colorScheme.surface,
            style: theme.textTheme.bodyMedium,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: theme.iconTheme.color,
              size: 24.sp,
            ),
            items: rooms.map((room) {
              return DropdownMenuItem<String>(
                value: room.id,
                child: Text(
                  room.name,
                  style: theme.textTheme.bodyMedium,
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedRoomId = value),
          ),
        );
      },
    );
  }

  Widget _buildSensorTypeDropdown(ThemeData theme, bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: 1.w,
        ),
      ),
      child: DropdownButtonFormField<SensorCategory>(
        value: selectedSensorType,
        hint: Text(
          S.of(context).selectSensor,
          style: theme.inputDecorationTheme.hintStyle,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        dropdownColor: theme.colorScheme.surface,
        style: theme.textTheme.bodyMedium,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: theme.iconTheme.color,
          size: 24.sp,
        ),
        items: SensorCategory.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Row(
              children: [
                Image.asset(
                  type.imagePath,
                  color: theme.colorScheme.onSurface,
                  width: 30.w,
                  height: 30.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  type.name,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) => setState(() => selectedSensorType = value),
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is AddSensorLoadingState) {
            showToast(S.of(context).sensorAdded);
            context.pop();
          }
        },
        buildWhen: (current, previous) =>
            current is SensorState || current is AddSensorLoadingState,
        builder: (context, state) => DefaultButton(
          title: S.of(context).save,
          isLoading: state is AddSensorLoadingState,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              DashboardBloc.get().add(AddSensorEvent(Sensor(
                name: nameController.text,
                categoryId: selectedSensorType!.id,
                pinNumber: pinNumberController.text,
                roomId: selectedRoomId!,
                category: selectedSensorType!,
                description: descriptionController.text,
              )));
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    pinNumberController.dispose();
    super.dispose();
  }
}
