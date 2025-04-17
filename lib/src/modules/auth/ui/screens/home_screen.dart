import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/devices.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/profile_screen.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/text_home_screen.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/card_devices.dart';
import '../widgets/card_home_screen.dart';
import '../widgets/color_indicator.dart';
import '../widgets/large_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool lightBulbStatus = false;
  bool smartTVStatus = true;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetUsageReportEvent());
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
                        '9:41',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Dec 10, 2024',
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
                            '13 devices running',
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
                      double value = 0;
                      bool isError = false;

                      if (state is GetUsageReportSuccess) {
                        value = state.report.savingsPercentage ?? 0;
                      } else if (state is GetUsageReportError) {
                        isError = true;
                      } else if (state is GetUsageReportLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0, end: value),
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
                                                endValue: 33,
                                                color: Colors.green,
                                                startWidth: 20,
                                                endWidth: 20,
                                              ),
                                              GaugeRange(
                                                startValue: 33,
                                                endValue: 66,
                                                color: Colors.orange,
                                                startWidth: 20,
                                                endWidth: 20,
                                              ),
                                              GaugeRange(
                                                startValue: 66,
                                                endValue: 80,
                                                color: Colors.yellow,
                                                startWidth: 20,
                                                endWidth: 20,
                                              ),
                                              GaugeRange(
                                                startValue: 80,
                                                endValue: 100,
                                                color: Colors.red,
                                                startWidth: 20,
                                                endWidth: 20,
                                              ),
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
                                                  S.of(context).low,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                angle: 170,
                                                positionFactor: 1,
                                              ),
                                              GaugeAnnotation(
                                                widget: Text(
                                                  S.of(context).high,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                angle: 10,
                                                positionFactor: 1,
                                              ),
                                              GaugeAnnotation(
                                                widget: Text(
                                                  '${animatedValue.toInt()}%',
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                angle: 80,
                                                positionFactor: 0.2,
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
                                      label: S.of(context).low),
                                  SizedBox(height: 10.h),
                                  ColorIndicator(
                                      color: Colors.orange,
                                      label: S.of(context).medium),
                                  SizedBox(height: 10.h),
                                  ColorIndicator(
                                      color: Colors.yellow,
                                      label: S.of(context).high),
                                  SizedBox(height: 10.h),
                                  ColorIndicator(
                                      color: Colors.red,
                                      label: S.of(context).veryHigh),
                                ],
                              ),
                            ],
                          ),
                          if (isError)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<DashboardBloc>()
                                      .add(GetUsageReportEvent());
                                },
                                icon: Icon(Icons.refresh),
                                label: Text(S.of(context).retry),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
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
                      double value = 0;
                      String tier = S.of(context).unknown;

                      if (state is GetUsageReportSuccess) {
                        value = state.report.savingsPercentage ?? 0;

                        if (value <= 32) {
                          tier = S.of(context).low;
                        } else if (value <= 65) {
                          tier = S.of(context).medium;
                        } else if (value <= 79) {
                          tier = S.of(context).high;
                        } else {
                          tier = S.of(context).veryHigh;
                        }
                      }
                      return Center(
                        child: CustomTextWidget(
                          label:
                              '${S.of(context).currentSavings} ${value.toInt()}% ${S.of(context).inThe} $tier ${S.of(context).tier}',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DeviceCard(
                        icon: Icons.lightbulb_outline,
                        deviceName: 'Light bulbs',
                        deviceType: 'Philips Hue 2',
                        isActive: lightBulbStatus,
                        onToggle: (value) {
                          setState(() {
                            lightBulbStatus = value;
                          });
                        },
                        onEdit: () {},
                      ),
                      SizedBox(width: 16),
                      DeviceCard(
                        icon: Icons.tv,
                        deviceName: 'Smart TV',
                        deviceType: 'LG',
                        isActive: smartTVStatus,
                        onToggle: (value) {
                          setState(() {
                            smartTVStatus = value;
                          });
                        },
                        onEdit: () {},
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
