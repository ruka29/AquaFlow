import 'package:aquaflow_mobile/screens/device_details.dart';
import 'package:aquaflow_mobile/screens/device_settings.dart';
import 'package:aquaflow_mobile/screens/main_page.dart';
import 'package:aquaflow_mobile/screens/search_devices.dart';
import 'package:flutter/material.dart';
import 'services/toggle_screens.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AquaFlow",
      // home: ToggleScreens(),
      // home: DeviceDetailsPage(),
      home: MainPage(),
      // home: DeviceSettings(),
      // home: SearchDevices(),
    );
  }
}