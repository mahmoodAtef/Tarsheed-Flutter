import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/profile_screen.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/text_home_screen.dart';
import 'package:tarsheed/src/modules/dashboard/bloc/dashboard_bloc.dart';
import '../../../../core/error/exception_manager.dart';
import '../widgets/bottomNavigatorBar.dart';
import '../widgets/card_home_screen.dart';
import '../widgets/color_indicator.dart';
import '../widgets/large_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
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
          bottomNavigationBar: BottomNavigator(),
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(194),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                  bottom: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('9:41',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(height: 4),
                      Text('Dec 10, 2024',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Home',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '13 devices running',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
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
                          radius: 25,
                          child: Image.asset("assets/images/avatar.png"),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Energy consumption',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
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
                                                widget: Text('LOW',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black)),
                                                angle: 170,
                                                positionFactor: 1,
                                              ),
                                              GaugeAnnotation(
                                                widget: Text('HIGH',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black)),
                                                angle: 10,
                                                positionFactor: 1,
                                              ),
                                              GaugeAnnotation(
                                                widget: Text(
                                                  '${animatedValue.toInt()}%',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black),
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
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ColorIndicator(
                                      color: Colors.green, label: 'Low'),
                                  SizedBox(height: 10),
                                  ColorIndicator(
                                      color: Colors.orange, label: 'Medium'),
                                  SizedBox(height: 10),
                                  ColorIndicator(
                                      color: Colors.yellow, label: 'High'),
                                  SizedBox(height: 10),
                                  ColorIndicator(
                                      color: Colors.red, label: 'Very High'),
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
                                label: Text("Retry"),
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
                  SizedBox(height: 8),
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      double value = 0;
                      String tier = 'Unknown';

                      if (state is GetUsageReportSuccess) {
                        value = state.report.savingsPercentage ?? 0;

                        if (value <= 32) {
                          tier = 'Low';
                        } else if (value <= 65) {
                          tier = 'Medium';
                        } else if (value <= 79) {
                          tier = 'High';
                        } else {
                          tier = 'Very High';
                        }
                      }

                      return Center(
                        child: CustomTextWidget(
                          label:
                              'Your Current Savings is ${value.toInt()}%, which is in the $tier tier',
                          size: 12,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32),
                  CustomTextWidget(label: 'Active Mode', size: 24),
                  SizedBox(height: 16),
                  Center(
                    child: DefaultButton(
                      title: "Energy Saving",
                      icon: Image.asset("assets/images/Vector.png"),
                      width: 300,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(label: 'Connected Devices', size: 22),
                      TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF366692),
                        ),
                        label: Text('View all',
                            style: TextStyle(
                                color: Color(0xFF366692),
                                fontSize: 10,
                                fontWeight: FontWeight.w400)),
                        icon: Icon(Icons.arrow_forward,
                            size: 10, color: Color(0xFF366692)),
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
