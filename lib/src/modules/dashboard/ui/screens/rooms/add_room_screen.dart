import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/large_button.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRoomDetailsCard(theme),
              SizedBox(height: 24.h),
              _buildSaveButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(
        S.of(context).addRoom,
        style: theme.appBarTheme.titleTextStyle,
      ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: theme.appBarTheme.elevation,
      centerTitle: theme.appBarTheme.centerTitle,
      iconTheme: theme.appBarTheme.iconTheme,
      surfaceTintColor: theme.appBarTheme.surfaceTintColor,
      actions: [
        BlocConsumer<DashboardBloc, DashboardState>(
          listenWhen: (context, state) =>
              state is AddRoomSuccess || state is AddRoomError,
          listener: (context, state) {
            if (state is AddRoomSuccess) {
              _showSuccessSnackBar(theme);
            } else if (state is AddRoomError) {
              ExceptionManager.showMessage(state.exception);
            }
          },
          builder: (context, state) {
            return TextButton(
              onPressed: _saveRoom,
              style: theme.textButtonTheme.style?.copyWith(
                foregroundColor: MaterialStateProperty.all(
                  theme.colorScheme.onPrimary,
                ),
              ),
              child: Text(
                S.of(context).save,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRoomDetailsCard(ThemeData theme) {
    return Card(
      color: theme.cardTheme.color,
      elevation: theme.cardTheme.elevation,
      shadowColor: theme.cardTheme.shadowColor,
      shape: theme.cardTheme.shape,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).roomDetails,
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 16.h),
            _buildNameField(theme),
            SizedBox(height: 16.h),
            _buildDescriptionField(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(ThemeData theme) {
    return TextFormField(
      controller: _nameController,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: S.of(context).roomName,
        labelStyle: theme.inputDecorationTheme.labelStyle,
        hintStyle: theme.inputDecorationTheme.hintStyle,
        prefixIcon: Icon(
          Icons.meeting_room,
          color: theme.iconTheme.color,
          size: theme.iconTheme.size,
        ),
        filled: theme.inputDecorationTheme.filled,
        fillColor: theme.inputDecorationTheme.fillColor,
        border: theme.inputDecorationTheme.border,
        enabledBorder: theme.inputDecorationTheme.enabledBorder,
        focusedBorder: theme.inputDecorationTheme.focusedBorder,
        errorBorder: theme.inputDecorationTheme.errorBorder,
        focusedErrorBorder: theme.inputDecorationTheme.focusedErrorBorder,
        contentPadding: theme.inputDecorationTheme.contentPadding,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? S.of(context).requiredField : null,
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return TextFormField(
      controller: _descriptionController,
      style: theme.textTheme.bodyMedium,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: S.of(context).roomDescription,
        labelStyle: theme.inputDecorationTheme.labelStyle,
        hintStyle: theme.inputDecorationTheme.hintStyle,
        prefixIcon: Icon(
          Icons.description,
          color: theme.iconTheme.color,
          size: theme.iconTheme.size,
        ),
        filled: theme.inputDecorationTheme.filled,
        fillColor: theme.inputDecorationTheme.fillColor,
        border: theme.inputDecorationTheme.border,
        enabledBorder: theme.inputDecorationTheme.enabledBorder,
        focusedBorder: theme.inputDecorationTheme.focusedBorder,
        errorBorder: theme.inputDecorationTheme.errorBorder,
        focusedErrorBorder: theme.inputDecorationTheme.focusedErrorBorder,
        contentPadding: theme.inputDecorationTheme.contentPadding,
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return BlocProvider.value(
      value: DashboardBloc.get(),
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is AddRoomSuccess) {
            context.pop();
            _showSuccessSnackBar(theme);
          } else if (state is AddRoomError) {
            ExceptionManager.showMessage(state.exception);
          }
        },
        buildWhen: (current, previous) =>
            current is AddRoomLoading || current is AddRoomSuccess,
        builder: (context, state) {
          return SizedBox(
            height: 50.h,
            child: DefaultButton(
              title: S.of(context).save,
              onPressed: _saveRoom,
              isLoading: state is AddRoomLoading,
            ),
          );
        },
      ),
    );
  }

  void _showSuccessSnackBar(ThemeData theme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.of(context).roomAddedSuccessfully,
          style: theme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: theme.snackBarTheme.backgroundColor,
        behavior: theme.snackBarTheme.behavior,
        shape: theme.snackBarTheme.shape,
      ),
    );
  }

  void _saveRoom() {
    if (_formKey.currentState!.validate()) {
      DashboardBloc.get().add(
        AddRoomEvent(
          Room(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            devicesIds: [],
            id: "",
          ),
        ),
      );
    }
  }
}
