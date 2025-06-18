import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/reports_cubit/reports_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';

import '../../../../../../generated/l10n.dart';
import '../widgets/color_indicator.dart';

class EnergyConsumptionSection extends StatefulWidget {
  @override
  State<EnergyConsumptionSection> createState() =>
      _EnergyConsumptionSectionState();
}

class _EnergyConsumptionSectionState extends State<EnergyConsumptionSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _targetValue = 0.0;
  double _currentAnimatedValue = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animation.addListener(() {
      setState(() {
        _currentAnimatedValue = _animation.value;
      });
    });

    final reportsCubit = context.read<ReportsCubit>();
    if (reportsCubit.state.report == null) {
      reportsCubit.getUsageReport(
          period: "${DateTime.now().month}-${DateTime.now().year}");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateToValue(double newValue) {
    if (_targetValue != newValue) {
      _targetValue = newValue;

      _animation = Tween<double>(
        begin: _currentAnimatedValue,
        end: newValue,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportsCubit, ReportsState>(
      listener: (context, state) {
        if (state is GetUsageReportError) {
          ExceptionManager.showMessage(state.exception);
        }
      },
      builder: (context, state) {
        if (state is GetUsageReportLoading) {
          return SizedBox(
            height: 300.h,
            child: Center(child: CustomLoadingWidget()),
          );
        }

        if (state is GetUsageReportError) {
          return SizedBox(
            height: 300.h,
            child: Center(
              child: CustomErrorWidget(exception: state.exception),
            ),
          );
        }

        if (state is GetUsageReportSuccess || state.report != null) {
          return _buildGaugeContent(context, state.report);
        }

        return _buildGaugeContent(context, null);
      },
    );
  }

  Widget _buildGaugeContent(BuildContext context, Report? report) {
    double consumptionValue = 0;
    int tierNumber = 1;

    if (report != null) {
      consumptionValue = report.totalConsumption;
      tierNumber = report.tier;
    }

    final gaugeValue = (consumptionValue > 1000)
        ? 100.0
        : (consumptionValue / 10).clamp(0, 100).toDouble();

    // بدء الأنيميشن للقيمة الجديدة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateToValue(gaugeValue);
    });

    return SizedBox(
      height: 300.h,
      child: Column(
        children: [
          Text(
            S.of(context).energyConsumption,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          startAngle: 180,
                          endAngle: 0,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: AxisLineStyle(
                            thickness: 20,
                            color: Colors.grey[200],
                          ),
                          ranges: _buildGaugeRanges(context),
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value:
                                  _currentAnimatedValue, // استخدام القيمة المتحركة
                              needleColor: Colors.black,
                              needleStartWidth: 2,
                              needleEndWidth: 5,
                              knobStyle: const KnobStyle(
                                knobRadius: 0.05,
                                color: Colors.black,
                              ),
                              // إضافة أنيميشن للمؤشر نفسه
                              animationType: AnimationType.ease,
                              enableAnimation: true,
                              animationDuration: 1500,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            _buildGaugeAnnotation("0-50", 175, 0.9),
                            _buildGaugeAnnotation("1000+", 5, 0.9),
                            GaugeAnnotation(
                              widget: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // أنيميشن للنص أيضاً
                                  AnimatedBuilder(
                                    animation: _animation,
                                    builder: (context, child) {
                                      // حساب القيمة الحقيقية من القيمة المتحركة
                                      double animatedConsumption =
                                          (_currentAnimatedValue * 10)
                                              .clamp(0, 1000);
                                      if (consumptionValue > 1000) {
                                        animatedConsumption = consumptionValue *
                                            (_currentAnimatedValue / 100);
                                      }

                                      return Text(
                                        '${animatedConsumption.toInt()} kWh',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    '${S.of(context).tier} $tierNumber',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              angle: 90,
                              positionFactor: 0.5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorIndicator(
                        color: Colors.green, label: S.of(context).tier1),
                    SizedBox(height: 10.h),
                    ColorIndicator(
                        color: Colors.lightGreen, label: S.of(context).tier2),
                    SizedBox(height: 10.h),
                    ColorIndicator(
                        color: Colors.yellow, label: S.of(context).tier3),
                    SizedBox(height: 10.h),
                    ColorIndicator(
                        color: Colors.orange, label: S.of(context).tier4),
                    SizedBox(height: 10.h),
                    ColorIndicator(
                        color: Colors.deepOrange, label: S.of(context).tier5),
                    SizedBox(height: 10.h),
                    ColorIndicator(
                        color: Colors.red, label: S.of(context).tier6Plus),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              S.of(context).currentTier(tierNumber),
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  List<GaugeRange> _buildGaugeRanges(BuildContext context) {
    return <GaugeRange>[
      GaugeRange(
        startValue: 0,
        endValue: 5,
        color: Colors.green,
        startWidth: 20,
        endWidth: 20,
        label: "1",
        labelStyle:
            GaugeTextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
      GaugeRange(
        startValue: 5,
        endValue: 10,
        color: Colors.lightGreen,
        startWidth: 20,
        endWidth: 20,
        label: "2",
        labelStyle:
            GaugeTextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
      GaugeRange(
        startValue: 10,
        endValue: 20,
        color: Colors.yellow,
        startWidth: 20,
        endWidth: 20,
        label: "3",
        labelStyle:
            GaugeTextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
      GaugeRange(
        startValue: 20,
        endValue: 35,
        color: Colors.orange,
        startWidth: 20,
        endWidth: 20,
        label: "4",
        labelStyle:
            GaugeTextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
      GaugeRange(
        startValue: 35,
        endValue: 65,
        color: Colors.deepOrange,
        startWidth: 20,
        endWidth: 20,
        label: "5",
        labelStyle:
            GaugeTextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
      GaugeRange(
        startValue: 65,
        endValue: 100,
        color: Colors.red,
        startWidth: 20,
        endWidth: 20,
        label: "6",
        labelStyle:
            GaugeTextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    ];
  }

  GaugeAnnotation _buildGaugeAnnotation(
      String text, double angle, double positionFactor) {
    return GaugeAnnotation(
      widget: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      angle: angle,
      positionFactor: positionFactor,
    );
  }
}
