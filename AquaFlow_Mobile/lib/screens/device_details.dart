import 'dart:convert';

import 'package:aquaflow_mobile/screens/device_settings.dart';
import 'package:aquaflow_mobile/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/styles_&_fn_handle.dart';

class DeviceDetailsPage extends StatefulWidget {
  const DeviceDetailsPage({super.key});

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    double tankFullPercentage = 0.7; // 30% full

    void updateTankLevel(double newPercentage) {
      setState(() {
        // Ensure percentage is between 0 and 1
        tankFullPercentage = newPercentage.clamp(0.0, 1.0);
      });
    }

    return Scaffold(
      appBar: AppBar(
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

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Main Water Tank",
                        style: TextStyle(
                          fontFamily: "Nunito-Bold",
                          fontSize: 23.0,
                          color: Colors.black,
                        ),
                      ),

                      Text(
                        "Online",
                        style: TextStyle(
                            fontFamily: "Nunito-Bold",
                            fontSize: 12.0,
                            color: Colors.green
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
                          SizedBox(height: 10.0 + (tankFullPercentage * 80)),

                          Text(
                            "Max Level: 90%",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black54.withOpacity(1 - tankFullPercentage)
                            ),
                          ),

                          SizedBox(height: 20.0 - (tankFullPercentage * 15)),

                          SizedBox(height: 20.0 + (tankFullPercentage * 80)),

                          Text(
                            "Min Level: 20%",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black54.withOpacity(tankFullPercentage)
                            ),
                          ),

                          SizedBox(height: 10.0 - (tankFullPercentage * 10))
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 10.0,),

                  Center(
                    child: Text(
                      "Remaining: ${(tankFullPercentage * 100).toStringAsFixed(0)}% (${(tankFullPercentage * 1000).toStringAsFixed(0)} L)",
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
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
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
                        value: true,
                        onChanged: (value) {
                          setState(() {
                            var waterValueSwitch = value;
                          });
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 20.0,),

                  const Text(
                    "Last 7 Days Usage",
                    style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                    ),
                  ),


                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
