import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/report_large_card.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/usage_card.dart';
import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../dashboard/bloc/dashboard_bloc.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/chart.dart';
import '../widgets/large_button.dart';
import '../widgets/month_navigaion.dart';
import '../widgets/select_time_period.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final List<String> _periods = ['Today', 'Week', 'Month', 'Years'];
  int _selectedPeriodIndex = 3;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetUsageReportEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      appBar: CustomAppBar(text: S.of(context).Reports),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is GetUsageReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetUsageReportError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ExceptionManager.showMessage(state.exception);
            });
            return const Center(child: Text('Error loading report data'));
          } else if (state is GetUsageReportSuccess) {
            final report = state.report;

            final avgUsage = (report.period != null && report.period != 0)
                ? (report.totalConsumption / report.period!).toStringAsFixed(2)
                : report.totalConsumption.toStringAsFixed(2);

            final avgCost = (report.totalConsumption * 0.85).toStringAsFixed(2);
            final lastMonthUsage =
                report.previousConsumption.toStringAsFixed(2);
            final nextMonthUsage =
                (report.totalConsumption * 1.05).toStringAsFixed(2);
            final savingsPercentage =
                report.savingsPercentage.toStringAsFixed(0);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    PeriodFilter(
                      periods: _periods,
                      initialSelectedIndex: _selectedPeriodIndex,
                      onPeriodChanged: (int index) {
                        setState(() {
                          _selectedPeriodIndex = index;
                        });
                        context
                            .read<DashboardBloc>()
                            .add(GetUsageReportEvent(period: index));
                      },
                    ),
                    UsageChartWidget(),
                    MonthNavigator(),
                    BuildInfoCard(
                      icon: Icons.show_chart,
                      title: 'Avg Usage',
                      value: '$avgUsage kWh',
                      percentage: '$savingsPercentage%',
                      isDecrease: true,
                      color: ColorManager.primary,
                    ),
                    const SizedBox(height: 10),
                    BuildInfoCard(
                      icon: Icons.attach_money,
                      title: 'Avg Cost',
                      value: '\$$avgCost',
                      percentage: '12%',
                      isDecrease: true,
                      color: ColorManager.primary,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UsageCard(
                          title: 'Last Month Usage',
                          value: '$lastMonthUsage kWh',
                        ),
                        const SizedBox(width: 12),
                        UsageCard(
                          title: 'Next Month Usage',
                          value: '$nextMonthUsage kWh',
                          subtitle: 'Projected based on your usage history',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const DefaultButton(
                      title: "You are now on the low-tier system",
                    )
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
