import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/widgets/connectivity_widget.dart';
import 'package:tarsheed/src/core/widgets/core_widgets.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/devices_cubit/devices_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/cubits/reports_cubit/reports_cubit.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/report.dart';
import 'package:tarsheed/src/modules/dashboard/ui/screens/devices/devices.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/devices/card_devices.dart';
import 'package:tarsheed/src/modules/dashboard/ui/widgets/text_home_screen.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/profile_screen.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../widgets/color_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<DevicesCubit>(
        create: (context) => DevicesCubit.get(),
        child: ConnectionWidget(
          onRetry: _initializeData,
          child: SingleChildScrollView(
            child: Builder(builder: (context) {
              _initializeData();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderSection(),
                  _EnergyConsumptionSection(),
                  _HomeContentSection(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = DashboardBloc.get();
      final reportsCubit = ReportsCubit.get();
      final DevicesCubit devicesCubit = DevicesCubit.get();
      final now = DateTime.now();
      reportsCubit.getUsageReport(period: "${now.month}-${now.year}");
      bloc.add(GetRoomsEvent());
      bloc.add(GetDevicesCategoriesEvent());
      devicesCubit.getDevices();
    });
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              _ClockWidget(),
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
              _ConnectedDevicesIndicator(),
            ],
          ),
          _ProfileAvatar(),
        ],
      ),
    );
  }
}

class _ClockWidget extends StatefulWidget {
  @override
  State<_ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<_ClockWidget> {
  String currentTime = '';
  String currentDate = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer =
        Timer.periodic(const Duration(minutes: 1), (_) => _updateDateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    final egyptTime = DateTime.now().toUtc().add(const Duration(hours: 2));

    try {
      final timeFormatter = DateFormat('h:mm a');
      currentTime = timeFormatter.format(egyptTime);

      final dateFormatter = DateFormat('d MMM, yyyy');
      currentDate = dateFormatter.format(egyptTime);
    } catch (e) {
      final hour = egyptTime.hour % 12 == 0 ? 12 : egyptTime.hour % 12;
      final hourFormat = hour < 10 ? '0$hour' : '$hour';
      final minuteFormat = egyptTime.minute < 10
          ? '0${egyptTime.minute}'
          : '${egyptTime.minute}';
      final period = egyptTime.hour < 12 ? 'AM' : 'PM';
      currentTime = '$hourFormat:$minuteFormat $period';

      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      currentDate =
          '${egyptTime.day} ${months[egyptTime.month - 1]}, ${egyptTime.year}';
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}

class _ConnectedDevicesIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesCubit, DevicesState>(
      buildWhen: (previous, current) =>
          current is GetDevicesLoading ||
          current is GetDevicesSuccess ||
          current is GetDevicesError ||
          current is ToggleDeviceStatusSuccess,
      builder: (context, state) {
        return Row(
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
              " ${state.devices?.where((e) => e.state == true).length}"
              " ${S.of(context).connectedDevices} ",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(ProfilePage()),
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
    );
  }
}

class _EnergyConsumptionSection extends StatefulWidget {
  @override
  State<_EnergyConsumptionSection> createState() =>
      _EnergyConsumptionSectionState();
}

class _EnergyConsumptionSectionState extends State<_EnergyConsumptionSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _currentGaugeValue = 0.0;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateGaugeValue(double newValue) {
    if (_currentGaugeValue != newValue) {
      setState(() {
        _currentGaugeValue = newValue;
        _animation = Tween<double>(
          begin: _hasAnimated ? _animation.value : 0,
          end: newValue,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
        _hasAnimated = true;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportsCubit, ReportsState>(
      listenWhen: (previous, current) =>
          current is GetUsageReportSuccess || current is GetUsageReportError,
      listener: (context, state) {
        if (state is GetUsageReportError) {
          ExceptionManager.showMessage(state.exception);
        }
      },
      buildWhen: (previous, current) =>
          current is GetUsageReportLoading ||
          current is GetUsageReportSuccess ||
          current is GetUsageReportError,
      builder: (context, state) {
        if (state is GetUsageReportLoading) {
          return SizedBox(
            height: 120.h,
            child: CustomLoadingWidget(),
          );
        }

        if (state is GetUsageReportError) {
          return SizedBox(
            height: 120.h,
            child: Center(
              child: CustomErrorWidget(
                exception: state.exception,
              ),
            ),
          );
        }

        Report? report;
        if (state is GetUsageReportSuccess) {
          report = state.report;
        }

        return _buildGaugeContent(context, report);
      },
    );
  }

  Widget _buildGaugeContent(BuildContext context, Report? report) {
    double consumptionValue = 0;
    int tierNumber = 1;

    if (report != null) {
      consumptionValue = (report.totalConsumption);
      tierNumber = report.tier;
    }

    final gaugeValue = (consumptionValue > 1000)
        ? 100.0
        : (consumptionValue / 10).clamp(0, 100).toDouble();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateGaugeValue(gaugeValue);
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
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
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
                              ranges: _buildGaugeRanges(context),
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: _animation.value,
                                  needleColor: Colors.black,
                                  needleStartWidth: 2,
                                  needleEndWidth: 5,
                                  knobStyle: const KnobStyle(
                                    knobRadius: 0.05,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                _buildGaugeAnnotation("0-50", 175, 0.9),
                                _buildGaugeAnnotation("1000+", 5, 0.9),
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
                        );
                      },
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
            child: CustomTextWidget(
              label: S.of(context).currentTier(tierNumber),
              size: 12.sp,
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

class _HomeContentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _ActiveModeSection(),
          SizedBox(height: 24.h),
          _ConnectedDevicesSection(),
        ],
      ),
    );
  }
}

class _ConnectedDevicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
                label: S.of(context).connectedDevices, size: 22.sp),
            TextButton.icon(
              onPressed: () => context.push(BlocProvider.value(
                value: DevicesCubit.get(),
                child: DevicesScreen(),
              )),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF366692),
              ),
              label: Text(
                S.of(context).viewAll,
                style: TextStyle(
                  color: const Color(0xFF366692),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              icon: Icon(
                Icons.arrow_forward,
                size: 10.sp,
                color: const Color(0xFF366692),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 175.h,
          child: BlocProvider.value(
            value: DevicesCubit
                .get(), // Use .value to get the same singleton instance
            child: BlocBuilder<DevicesCubit, DevicesState>(
              buildWhen: (previous, current) {
                // Rebuild on any device state change
                return current is GetDevicesLoading ||
                    current is GetDevicesSuccess ||
                    current is GetDevicesError ||
                    current is ToggleDeviceStatusLoading ||
                    current is ToggleDeviceStatusSuccess ||
                    current is ToggleDeviceStatusError ||
                    previous.devices != current.devices;
              },
              builder: (context, state) {
                if (state is GetDevicesSuccess ||
                    state.devices
                            ?.where((e) => e.state == true)
                            .toList()
                            .isNotEmpty ==
                        true) {
                  return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.devices!
                                  .where((e) => e.state == true)
                                  .toList()
                                  .length >
                              3
                          ? 3
                          : state.devices!
                              .where((e) => e.state == true)
                              .toList()
                              .length,
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                      itemBuilder: (context, index) {
                        final device = state.devices
                            ?.where((e) => e.state == true)
                            .toList()[index];
                        return DeviceCard(device: device!);
                      });
                }
                if (_checkIfDevicesLoading(state)) {
                  return const Center(child: CustomLoadingWidget());
                } else if (_checkIfDevicesError(state)) {
                  return Center(
                    child: CustomErrorWidget(
                      height: 110.h,
                      exception: (state as GetDevicesError).exception,
                    ),
                  );
                }
                return Center(
                  child: NoDataWidget(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  bool _checkIfDevicesLoading(DevicesState state) {
    if ((state is GetDevicesLoading && (state.devices == null)) ||
        state is DevicesInitial) {
      return true;
    } else {
      return false;
    }
  }

  bool _checkIfDevicesError(DevicesState state) {
    if (state is GetDevicesError) {
      return true;
    } else {
      return false;
    }
  }
}
