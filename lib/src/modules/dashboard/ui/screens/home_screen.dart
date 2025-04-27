import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/devices.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/text_home_screen.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/profile_screen.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../../../core/widgets/bottomNavigatorBar.dart';
import '../../../../core/widgets/large_button.dart';
import '../widgets/color_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool lightBulbStatus = false;
  bool smartTVStatus = true;

  String currentTime = '';
  String currentDate = '';

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<DashboardBloc>();
    bloc.add(GetUsageReportEvent(period: "${DateTime.now().month}-${DateTime.now().year}"));
    bloc.add(GetRoomsEvent());
    bloc.add(GetDevicesCategoriesEvent());
    context.read<DashboardBloc>().add(GetDevicesEvent());

    _updateDateTime();

    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _updateDateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    final egyptTime = DateTime.now().toUtc().add(Duration(hours: 2));

    try {
      final timeFormatter = DateFormat('h:mm a');
      currentTime = timeFormatter.format(egyptTime);

      final dateFormatter = DateFormat('d MMM, yyyy');
      currentDate = dateFormatter.format(egyptTime);
    } catch (e) {
      final hour = egyptTime.hour % 12 == 0 ? 12 : egyptTime.hour % 12;
      final hourFormat = hour < 10 ? '0$hour' : '$hour';
      final minuteFormat = egyptTime.minute < 10 ? '0${egyptTime.minute}' : '${egyptTime.minute}';
      final period = egyptTime.hour < 12 ? 'AM' : 'PM';
      currentTime = '$hourFormat:$minuteFormat $period';

      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      currentDate = '${egyptTime.day} ${months[egyptTime.month - 1]}, ${egyptTime.year}';
    }

    if (mounted) {
      setState(() {});
    }
  }

  // تحديد رقم الشريحة بناءً على الاستهلاك
  int getElectricityTierNumber(double consumption) {
    if (consumption <= 50) {
      return 1;
    } else if (consumption <= 100) {
      return 2;
    } else if (consumption <= 200) {
      return 3;
    } else if (consumption <= 350) {
      return 4;
    } else if (consumption <= 650) {
      return 5;
    } else if (consumption <= 1000) {
      return 6;
    } else {
      return 7;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is GetUsageReportError) {
            ExceptionManager.showMessage(state.exception);
          }
        },
        child: Scaffold(
          bottomNavigationBar: const BottomNavigator(currentIndex: 0),
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(194.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50.r),
                  bottom: Radius.circular(30.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTime,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        currentDate,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        S.of(context).home,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.h,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "13 devices running",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(ProfilePage());
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          child: Image.asset("assets/images/avatar.png"),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    S.of(context).energyConsumption,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      double consumptionValue = 0;
                      bool isError = false;

                      if (state is GetUsageReportSuccess) {
                        // التأكد من أن savingsPercentage مش null
                        consumptionValue = state.report.savingsPercentage ?? 0;
                        // تحويل النسبة المئوية إلى قيمة استهلاك تقريبية
                        consumptionValue = consumptionValue * 15; // تحويل إلى قيمة بين 0-1500
                      } else if (state is GetUsageReportError) {
                        isError = true;
                      } else if (state is GetUsageReportLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // احصل على رقم الشريحة
                      final tierNumber = getElectricityTierNumber(consumptionValue);

                      // قيمة للعرض على المقياس (بين 0 و 100)
                      final gaugeValue = (consumptionValue > 1000)
                          ? 100.0
                          : (consumptionValue / 10).clamp(0, 100).toDouble();

                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0, end: gaugeValue),
                                    duration: Duration(seconds: 2),
                                    builder: (context, animatedValue, child) {
                                      return SfRadialGauge(
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
                                            ranges: <GaugeRange>[

                                              GaugeRange(
                                                  startValue: 0,
                                                  endValue: 5, // 50/10
                                                  color: Colors.green,
                                                  startWidth: 20,
                                                  endWidth: 20,
                                                  label: "1",
                                                  labelStyle: GaugeTextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.bold)),

                                              GaugeRange(
                                                  startValue: 5,
                                                  endValue: 10, // 100/10
                                                  color: Colors.lightGreen,
                                                  startWidth: 20,
                                                  endWidth: 20,
                                                  label: "2",
                                                  labelStyle: GaugeTextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.bold)),
                                              GaugeRange(
                                                  startValue: 10,
                                                  endValue: 20, // 200/10
                                                  color: Colors.yellow,
                                                  startWidth: 20,
                                                  endWidth: 20,
                                                  label: "3",
                                                  labelStyle: GaugeTextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.bold)),
                                              GaugeRange(
                                                  startValue: 20,
                                                  endValue: 35, // 350/10
                                                  color: Colors.orange,
                                                  startWidth: 20,
                                                  endWidth: 20,
                                                  label: "4",
                                                  labelStyle: GaugeTextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.bold)),
                                              GaugeRange(
                                                  startValue: 35,
                                                  endValue: 65, // 650/10
                                                  color: Colors.deepOrange,
                                                  startWidth: 20,
                                                  endWidth: 20,
                                                  label: "5",
                                                  labelStyle: GaugeTextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.bold)),
                                              GaugeRange(
                                                  startValue: 65,
                                                  endValue: 100, // 1000/10
                                                  color: Colors.red,
                                                  startWidth: 20,
                                                  endWidth: 20,
                                                  label: "6",
                                                  labelStyle: GaugeTextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                            pointers: <GaugePointer>[
                                              NeedlePointer(
                                                value: animatedValue,
                                                needleColor: Colors.black,
                                                needleStartWidth: 2,
                                                needleEndWidth: 5,
                                                knobStyle: KnobStyle(
                                                  knobRadius: 0.05,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                            annotations: <GaugeAnnotation>[
                                              GaugeAnnotation(
                                                widget: Text(
                                                  "0-50",
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                angle: 175,
                                                positionFactor: 0.9,
                                              ),
                                              GaugeAnnotation(
                                                widget: Text(
                                                  "1000+",
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                angle: 5,
                                                positionFactor: 0.9,
                                              ),
                                              GaugeAnnotation(
                                                widget: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      '${consumptionValue.toInt()} kWh',
                                                      style: TextStyle(
                                                        fontSize: 20.sp,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Tier $tierNumber',
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
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ColorIndicator(
                                      color: Colors.green,
                                      label: S.of(context).tier1),
                                  SizedBox(height: 10.h),
                                  ColorIndicator(
                                      color: Colors.lightGreen,
                                      label: S.of(context).tier2),
                                  SizedBox(height: 10.h),
                                  ColorIndicator(
                                      color: Colors.yellow,
                                      label: S.of(context).tier3),
                                  SizedBox(height: 10.h),
                                  ColorIndicator(
                                      color: Colors.orange,
                                      label: S.of(context).tier4),
                                  SizedBox(height: 10.h),
                                  ColorIndicator(
                                      color: Colors.deepOrange,
                                      label: S.of(context).tier5),
                                  SizedBox(height: 10.h),
                                  ColorIndicator(
                                      color: Colors.red,
                                      label: S.of(context).tier6Plus),
                                ],
                              ),
                            ],
                          ),
                          if (isError)
                            Padding(
                              padding: EdgeInsets.only(top: 16.h),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<DashboardBloc>()
                                      .add(GetUsageReportEvent());
                                },
                                icon: Icon(Icons.refresh, size: 20.sp),
                                label: Text(S.of(context).retry),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 8.h),
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      double consumptionValue = 0;
                      int tierNumber = 1;

                      if (state is GetUsageReportSuccess) {
                        consumptionValue = state.report.savingsPercentage ?? 0;
                        consumptionValue = consumptionValue * 15;
                        tierNumber = getElectricityTierNumber(consumptionValue);
                      }

                      return Center(
                        child: CustomTextWidget(
                          label: S.of(context).currentTier(tierNumber),
                          size: 12.sp,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  CustomTextWidget(
                      label: S.of(context).activeMode, size: 24.sp),
                  SizedBox(height: 16.h),
                  Center(
                    child: DefaultButton(
                      title: S.of(context).energySaving,
                      icon: Image.asset("assets/images/Vector.png"),
                      width: 300.w,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                          label: S.of(context).connectedDevices, size: 22.sp),
                      TextButton.icon(
                        onPressed: () {
                          context.push(DevicesScreen());
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF366692),
                        ),
                        label: Text(S.of(context).viewAll,
                            style: TextStyle(
                                color: Color(0xFF366692),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400)),
                        icon: Icon(Icons.arrow_forward,
                            size: 10.sp, color: Color(0xFF366692)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}