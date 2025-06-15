import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/automation/cubit/automation_cubit.dart';
import 'package:tarsheed/src/modules/automation/ui/screens/add_automation_screen.dart';
import 'package:tarsheed/src/modules/automation/ui/screens/automation_details_screen.dart';
import 'package:tarsheed/src/modules/automation/ui/widgets/automation_card.dart';

class AllAutomationsScreen extends StatelessWidget {
  const AllAutomationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).automations),
      ),
      body: BlocProvider(
        create: (context) => AutomationCubit.get()..getAllAutomations(),
        child: ConnectionWidget(
          onRetry: _fetchAutomations,
          child: BlocBuilder<AutomationCubit, AutomationState>(
              builder: (context, state) {
            if (state is GetAllAutomationsLoading) {
              return const CustomLoadingWidget();
            } else if (state is GetAllAutomationsError) {
              return Center(
                child: SizedBox(
                    height: 120.h,
                    child: CustomErrorWidget(exception: state.exception)),
              );
            } else if (state is GetAllAutomationsSuccess &&
                state.automations!.isEmpty) {
              return const NoDataWidget();
            } else if (state.automations != null) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.automations!.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final automation = state.automations![index];
                  return AutomationCard(
                    automation: automation,
                    onTap: () {
                      context.push(
                          AutomationDetailsScreen(automation: automation));
                    },
                  );
                },
              );
            }
            return SizedBox();
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AddAutomationScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _fetchAutomations() => AutomationCubit.get().getAllAutomations();
}
