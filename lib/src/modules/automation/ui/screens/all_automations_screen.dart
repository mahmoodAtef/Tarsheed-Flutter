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
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).automations),
      ),
      body: BlocProvider.value(
        value: _automationCubit,
        child: ConnectionWidget(
          onRetry: _fetchAutomations,
          child: BlocConsumer<AutomationCubit, AutomationState>(
            listener: (context, state) {
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
            },
            builder: (context, state) {
              if (state is GetAllAutomationsLoading &&
                  state.automations == null) {
                return const CustomLoadingWidget();
              }

              if (state is GetAllAutomationsError &&
                  state.automations == null) {
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
                    ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: automations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final automation = automations[index];
                        return AutomationCard(
                          automation: automation,
                          isEnabled: automation.isEnabled ?? true,
                          onTap: () async {
                            final result = await context.push(
                              BlocProvider.value(
                                value: context.read<AutomationCubit>(),
                                child: AutomationDetailsScreen(
                                    automation: automation),
                              ),
                            );
                            if (result == true) {
                              _fetchAutomations();
                            }
                          },
                          onToggle: () {
                            if (automation.id != null) {
                              _automationCubit
                                  .changeAutomationStatus(automation.id!);
                            } else {
                              debugPrint(
                                  'Automation ID is null, cannot toggle status.');
                            }
                          },
                          onDelete: () {
                            _showDeleteDialog(automation);
                          },
                        );
                      },
                    ),
                    if (state is DeleteAutomationLoading ||
                        state is ChangeAutomationStatusLoading)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(const AddAutomationScreen());
          if (result == true) {
            _fetchAutomations();
          }
        },
        child: const Icon(Icons.add),
        tooltip: S.of(context).addNewAutomation,
      ),
    );
  }

  void _showDeleteDialog(Automation automation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteAutomation),
        content: Text(
          '${S.of(context).deleteAutomationConfirmation}\n\n"${automation.name}"',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (automation.id != null) {
                _automationCubit.deleteAutomation(automation.id!);
              }
            },
            child: Text(
              S.of(context).delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
