import 'package:flutter/material.dart';
import 'package:mobile/screens/device_settings.dart';
import 'package:mobile/theme.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeviceDetails extends StatefulWidget {
  const DeviceDetails({super.key});

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  int waterLevelLiters = 540; // Water level in liters
  double waterLevelPercentage = 0.3; // Water level percentage
  bool manualControlStatus = true; // Manual control switch state
  bool automateStatus = false; // Automate switch state

  // Water usage data
  int thisMonthUsage = 1200; // Current month water usage in liters
  int lastMonthUsage = 1000; // Last month water usage in liters

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'XYZ123',
                style: heading, // Updated style
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.gears),
              
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeviceSettings()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Text(
                    "Tank Water Level :",
                    style: blueHeading, // Updated style
                  ),
                  Text(
                    "$waterLevelLiters L",
                    style: subText, // Updated style
                  ),
                  const SizedBox(height: 20),
                  // Row for tank visualization and labels
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      // Tank Visualization
                      Stack(
                        children: [
                          // Tank background
                          Container(
                            width: 200,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                          ),
                          // Water level fill
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 200,
                              height: 250 * waterLevelPercentage,
                              decoration: const BoxDecoration(
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                          // Percentage text in the center
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                "${(waterLevelPercentage * 100).toInt()}%",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10), // Space between tank and labels
                      // Min and Max Level Labels
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Max Level
                          const SizedBox(
                            width: 20,
                            ),
                          Text(
                            "Max Level\n90%",
                            textAlign: TextAlign.center,
                            style:input,
                          ),
                          const SizedBox(height: 200), // Space between max and min
                          const SizedBox(
                            width: 20,
                            ),
                          // Min Level
                          Text(

                            "Min Level\n10%",
                            textAlign: TextAlign.center,
                            style: input,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manual Control",
                          style: subHeadingBlue, // Updated style
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Water Value",
                              style: subText, // Updated style
                            ),
                            Column(
                              children: [
                                SwitcherButton(
                                  value: manualControlStatus,
                                  onChange: (value) {
                                    setState(() {
                                      manualControlStatus = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  manualControlStatus ? "ON" : "OFF",
                                  style: subText, // Updated style
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Water Usage",
                          style: subHeadingGreen,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "This Month: $thisMonthUsage Liters",
                          style: subText, // Updated style
                        ),
                        Text(
                          "Last Month: $lastMonthUsage Liters",
                          style: subText, // Updated style
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              thisMonthUsage > lastMonthUsage
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: thisMonthUsage > lastMonthUsage
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              thisMonthUsage > lastMonthUsage
                                  ? "${thisMonthUsage - lastMonthUsage} Liters Higher"
                                  : "${lastMonthUsage - thisMonthUsage} Liters Lower",
                              style: subText, // Updated style
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DeviceDetails(),
  ));
}
