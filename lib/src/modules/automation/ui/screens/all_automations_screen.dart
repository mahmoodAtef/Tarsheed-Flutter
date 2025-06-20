import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/automation/cubit/automation_cubit.dart';
import 'package:tarsheed/src/modules/automation/data/models/automation.dart';
import 'package:tarsheed/src/modules/automation/ui/screens/add_automation_screen.dart';
import 'package:tarsheed/src/modules/automation/ui/screens/automation_details_screen.dart';
import 'package:tarsheed/src/modules/automation/ui/widgets/automation_card.dart';

class AllAutomationsScreen extends StatefulWidget {
  const AllAutomationsScreen({super.key});

  @override
  State<AllAutomationsScreen> createState() => _AllAutomationsScreenState();
}

class _AllAutomationsScreenState extends State<AllAutomationsScreen> {
  late AutomationCubit _automationCubit;

  @override
  void initState() {
    super.initState();
    _automationCubit = AutomationCubit.get();
    _fetchAutomations();
  }

  void _fetchAutomations() {
    _automationCubit.getAllAutomations();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).automations),
      ),
      body: BlocProvider.value(
        value: _automationCubit,
        child: ConnectionWidget(
          onRetry: _fetchAutomations,
          child: BlocConsumer<AutomationCubit, AutomationState>(
            listener: _handleStateChanges,
            builder: (context, state) => _buildBody(context, state, theme),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context, theme),
    );
  }

  void _handleStateChanges(BuildContext context, AutomationState state) {
    if (state is DeleteAutomationSuccess) {
      showToast(S.of(context).automationDeletedSuccessfully);
    } else if (state is DeleteAutomationError ||
        state is ChangeAutomationStatusError ||
        state is GetAllAutomationsError) {
      if (state is DeleteAutomationError) {
        ExceptionManager.showMessage(state.exception);
      } else if (state is ChangeAutomationStatusError) {
        ExceptionManager.showMessage(state.exception);
      } else if (state is GetAllAutomationsError) {
        ExceptionManager.showMessage(state.exception);
      }
    } else if (state is ChangeAutomationStatusSuccess) {
      showToast(S.of(context).automationStatusChanged);
    }
  }

  Widget _buildBody(
      BuildContext context, AutomationState state, ThemeData theme) {
    if (state is GetAllAutomationsLoading && state.automations == null) {
      return const CustomLoadingWidget();
    }

    if (state is GetAllAutomationsError && state.automations == null) {
      return Center(
        child: SizedBox(
          height: 120.h,
          child: CustomErrorWidget(
            exception: state.exception,
          ),
        ),
      );
    }

    final automations = state.automations ?? [];

    if (automations.isEmpty) {
      return const NoDataWidget();
    }

    return RefreshIndicator(
      onRefresh: () async => _fetchAutomations(),
      child: Stack(
        children: [
          _buildAutomationsList(automations, theme),
          if (state is DeleteAutomationLoading ||
              state is ChangeAutomationStatusLoading)
            _buildLoadingOverlay(theme),
        ],
      ),
    );
  }

  Widget _buildAutomationsList(List<Automation> automations, ThemeData theme) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: automations.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final automation = automations[index];
        return AutomationCard(
          automation: automation,
          isEnabled: automation.isEnabled ?? true,
          onTap: () => _handleAutomationTap(context, automation),
          onToggle: () => _handleToggleAutomation(automation),
          onDelete: () => _showDeleteDialog(automation, theme),
        );
      },
    );
  }

  Widget _buildLoadingOverlay(ThemeData theme) {
    return Container(
      color: theme.colorScheme.onSurface.withOpacity(0.3),
      child: Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, ThemeData theme) {
    return FloatingActionButton(
      onPressed: () => _handleAddAutomation(context),
      tooltip: S.of(context).addNewAutomation,
      child: Icon(
        Icons.add,
        color: theme.floatingActionButtonTheme.foregroundColor,
      ),
    );
  }

  Future<void> _handleAutomationTap(
      BuildContext context, Automation automation) async {
    final result = await context.push(
      BlocProvider.value(
        value: context.read<AutomationCubit>(),
        child: AutomationDetailsScreen(automation: automation),
      ),
    );
    if (result == true) {
      _fetchAutomations();
    }
  }

  void _handleToggleAutomation(Automation automation) {
    if (automation.id != null) {
      _automationCubit.changeAutomationStatus(automation.id!);
    } else {}
  }

  Future<void> _handleAddAutomation(BuildContext context) async {
    final result = await context.push(const AddAutomationScreen());
    if (result == true) {
      _fetchAutomations();
    }
  }

  void _showDeleteDialog(Automation automation, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        elevation: theme.dialogTheme.elevation,
        shape: theme.dialogTheme.shape,
        title: Text(
          S.of(context).deleteAutomation,
          style: theme.dialogTheme.titleTextStyle,
        ),
        content: Text(
          '${S.of(context).deleteAutomationConfirmation}\n\n"${automation.name}"',
          style: theme.dialogTheme.contentTextStyle,
        ),
        actions: [
          _buildDialogButton(
            context: context,
            text: S.of(context).cancel,
            onPressed: () => Navigator.of(context).pop(),
            theme: theme,
            isDestructive: false,
          ),
          _buildDialogButton(
            context: context,
            text: S.of(context).delete,
            onPressed: () => _handleDeleteConfirmation(automation),
            theme: theme,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required ThemeData theme,
    required bool isDestructive,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: theme.textButtonTheme.style?.copyWith(
        foregroundColor: MaterialStateProperty.all(
          isDestructive
              ? theme.colorScheme.error
              : theme.textButtonTheme.style?.foregroundColor?.resolve({}) ??
                  theme.colorScheme.primary,
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: isDestructive
              ? theme.colorScheme.error
              : theme.colorScheme.primary,
        ),
      ),
    );
  }

  void _handleDeleteConfirmation(Automation automation) {
    Navigator.of(context).pop();
    if (automation.id != null) {
      _automationCubit.deleteAutomation(automation.id!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
