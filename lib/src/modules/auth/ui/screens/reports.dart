import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/report_large_card.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/usage_card.dart';
import '../../../../../generated/l10n.dart';
import '../widgets/appbar.dart';
import '../widgets/bottomNavigatorBar.dart';
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
  int _selectedPeriodIndex = 3; // تبدأ بالشهر كما يظهر في الصورة
  String _currentMonth = 'October, 2024';

  // بيانات الرسم البياني
  final List<double> _chartData = [15, 145, 60, 90, 75, 40, 95, 135, 110, 200];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      appBar: CustomAppBar(text: S.of(context).Reports),
      body: SingleChildScrollView(
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
                },
              ),

              MonthNavigator(),
              BuildInfoCard(
                icon: Icons.show_chart,
                title: 'Avg Usage',
                value: '62.85kWh',
                percentage: '10%',
                isDecrease: true,
                color: ColorManager.primary,
              ),
              const SizedBox(height: 10),
              BuildInfoCard(
                icon: Icons.attach_money,
                title: 'Avg Cost',
                value: '\$125.5',
                percentage: '12%',
                isDecrease: true,
                color: ColorManager.primary,
              ),
              const SizedBox(height: 10),

              // استخدام الشهر الماضي والقادم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UsageCard(
                    title: 'Last Month Usage',
                    value: '146.85 kWh',
                  ),
                  const SizedBox(width: 12),
                  UsageCard(
                    title: 'Next Month Usage',
                    value: '146.85 kWh',
                    subtitle: 'Projected based on your usage history',
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // زر النظام منخفض التكلفة
              DefaultButton(
                title: "You are now on the low-tier system",
              )
            ],
          ),
        ),
      ),
    );
  }

  // بناء كارت الاستخدام الشهري مع الرسم البياني المخصص
  Widget _buildMonthlyUsageCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Usage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 8),
            const Row(
              children: [
                Text(
                  'kWh',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
