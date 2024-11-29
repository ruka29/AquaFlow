import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:aquaflow_mobile/screens/device_settings.dart';
import 'package:aquaflow_mobile/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/device_controller.dart';
import '../services/styles_&_fn_handle.dart';

class DeviceDetailsPage extends StatefulWidget {
  final String macAddress;
  const DeviceDetailsPage({super.key, required this.macAddress});

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  Map<String, dynamic>? deviceData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDeviceDetails();
  }

  Future<void> fetchDeviceDetails() async {
    final url = Uri.parse('https://5fjm2w12-5000.asse.devtunnels.ms/api/device/get-device');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'macAddress': widget.macAddress,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          deviceData = json.decode(response.body);
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch device details: ${response.body}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
      });
    }
  }

  List<String> getLast7Days() {
    final now = DateTime.now();
    final dateFormatter = DateFormat('MMM d');
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return dateFormatter.format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    double tankFullPercentage = deviceData != null && deviceData!['waterLevel'] != null
        ? deviceData!['waterLevel'] / 100
        : 0.0;

    double calculateEstimateUsage() {
      DateTime today = DateTime.now();

      if (deviceData == null) {
        return 0.0;
      }

      int totalDaysInMonth = DateTime(today.year, today.month + 1, 0).day;

      int remainingDays = totalDaysInMonth - today.day;

      int day1 = deviceData?['day1'] ?? 0;
      int day2 = deviceData?['day2'] ?? 0;
      int day3 = deviceData?['day3'] ?? 0;
      int day4 = deviceData?['day4'] ?? 0;
      int day5 = deviceData?['day5'] ?? 0;
      int day6 = deviceData?['day6'] ?? 0;
      int day7 = deviceData?['day7'] ?? 0;

      double averageUsage = (day1 + day2 + day3 + day4 + day5 + day6 + day7) / 7;

      double remainingMonthUsage = averageUsage * remainingDays;

      int thisMonthUsage = deviceData?['thisMonthUsage'] ?? 0;

      double estimateMonthlyUsage = thisMonthUsage + remainingMonthUsage;
      return double.parse(estimateMonthlyUsage.toStringAsFixed(2));
    }

    void updateTankLevel(double newPercentage) {
      setState(() {
        tankFullPercentage = newPercentage.clamp(0.0, 1.0);
      });
    }

    List<double> dailyUsages = [
      deviceData?['day1']?.toDouble() ?? 0,
      deviceData?['day2']?.toDouble() ?? 0,
      deviceData?['day3']?.toDouble() ?? 0,
      deviceData?['day4']?.toDouble() ?? 0,
      deviceData?['day5']?.toDouble() ?? 0,
      deviceData?['day6']?.toDouble() ?? 0,
      deviceData?['day7']?.toDouble() ?? 0,
    ];

    final last7Days = getLast7Days();

    final estimateUsage = calculateEstimateUsage();

    if (deviceData == null) {
      return Scaffold(
        body: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.lightBlue[100],
        surfaceTintColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  SlidePageRoute(
                    page: const DeviceSettings(),
                  ),
                );
              },
              icon: const Icon(Icons.settings_outlined),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    deviceData?['deviceName'],
                    style: const TextStyle(
                      fontFamily: "Nunito-Bold",
                      fontSize: 23.0,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    deviceData?['status'],
                    style: TextStyle(
                        fontFamily: "Nunito-Bold",
                        fontSize: 12.0,
                        color: deviceData?['status'] == "online" ? Colors.green : Colors.red
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 200.0,
                    width: 125.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Tank border color
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.black26, width: 2),
                    ),
                    child: Stack(
                      children: [
                        // Water level visualization
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: 200.0 * tankFullPercentage, // Dynamic height based on percentage
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.7), // Water color
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.black.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10), // Add some spacing

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Max Water Level: ${deviceData?['highThreshold']}%",
                        style: const TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                        ),
                      ),

                      const SizedBox(height: 10.0,),

                      Text(
                        "Min Water Level: ${deviceData?['lowThreshold']}%",
                        style: const TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 10.0,),

              Center(
                child: Text(
                  "Remaining: ${(tankFullPercentage * 100).toStringAsFixed(0)}% (${(tankFullPercentage * deviceData?['tankCapacity']).toStringAsFixed(0)} L)",
                  style: const TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: primaryColor
                  ),
                ),
              ),

              const SizedBox(height: 20.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Manual Control",
                    style: TextStyle(
                      fontFamily: "Nunito-Bold",
                      fontSize: 20.0
                    ),
                  ),

                  Switch(
                    activeColor: primaryColor,
                    thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Icon(Icons.power_settings_new_rounded, color: Colors.white);
                        }
                        return const Icon(Icons.power_settings_new_rounded, color: primaryColor);
                      },
                    ),
                    trackOutlineColor: MaterialStateProperty.all(primaryColor),
                    trackOutlineWidth: MaterialStateProperty.all(1),
                    value: deviceData?['valveState'],
                    onChanged: (value) async {
                      setState(() {
                        deviceData?['valveState'] = value;
                      });
                      try {
                        final response = await DeviceController.controlValve(deviceData?['macAddress'], value);

                        final responseData = json.decode(response.body);

                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("${responseData['message']}"),
                            ),
                          );
                        } else {
                          setState(() {
                            deviceData?['valveState'] = !value;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("${responseData['message']}"),
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error controlling valve: $e');
                        setState(() {
                          deviceData?['valveState'] = !value;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Error controlling valve: $e'),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),

              const SizedBox(height: 20.0,),

              const Text(
                "Last 7 Days Usage",
                style: TextStyle(
                    fontFamily: "Nunito-Bold",
                    fontSize: 20.0
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),

                    AspectRatio(
                      aspectRatio: 1.5,
                      child: BarChart(
                        BarChartData(
                          barGroups: List.generate(
                            dailyUsages.length,
                                (index) => BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: dailyUsages[index], // Usage value
                                  color: primaryColor, // Bar color
                                  width: 18, // Bar width
                                ),
                              ],
                            ),
                          ),

                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= last7Days.length) {
                                    return const Text('');
                                  }

                                  final label = index == 6 ? "Today" : last7Days[index];
                                  return Text(
                                    label,
                                    style: const TextStyle(
                                      fontFamily: "Nunito-Bold",
                                      fontSize: 12
                                    ),
                                  );
                                },
                              ),
                            ),

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString());
                                },
                              ),
                            ),

                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),

                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          alignment: BarChartAlignment.spaceBetween,
                          groupsSpace: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Monthly Usage",
                    style: TextStyle(
                      fontFamily: "Nunito-Bold",
                      fontSize: 20.0
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        estimateUsage > deviceData?['lastMonthUsage'] ? "Increased" : "Decreased",
                        style: TextStyle(
                          fontFamily: "Nunito-Bold",
                          fontSize: 12.0,
                          color: estimateUsage > deviceData?['lastMonthUsage'] ? Colors.red : Colors.green,
                        ),
                      ),

                      const SizedBox(width: 5.0,),

                      estimateUsage > deviceData?['lastMonthUsage'] ? const Icon(Icons.arrow_upward_rounded, color: Colors.red,) : const Icon(Icons.arrow_downward_rounded, color: Colors.green,)
                    ],
                  )
                ],
              ),

              const SizedBox(height: 15.0,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "This Month Usage",
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0
                      ),
                    ),

                    Text(
                      "${deviceData?['thisMonthUsage']} L",
                      style: const TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10.0,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Estimated Usage",
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 15.0
                      ),
                    ),

                    Text(
                      "$estimateUsage L",
                      style: const TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 15.0,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15.0,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Last Month Usage",
                      style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0
                      ),
                    ),

                    Text(
                      "${deviceData?['lastMonthUsage']} L",
                      style: const TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10.0,),
            ],
          ),
        ),
      ),
    );
  }
}
