import 'package:flutter/material.dart';
import 'package:mobile/theme.dart';

class DeviceSettings extends StatefulWidget {
  const DeviceSettings({super.key});

  @override
  State<DeviceSettings> createState() => _DeviceSettingsState();
}

class _DeviceSettingsState extends State<DeviceSettings> {
  final TextEditingController deviceNameController = TextEditingController(text: "Device321");
  final TextEditingController minLevelController = TextEditingController();
  final TextEditingController maxLevelController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String deviceName = "Device321";
  double minLevel = 0.0;
  double maxLevel = 100.0;
  double capacity = 0.0;
  double height = 0.0;

  void handleUpdateTap(String section) {
    // You can handle different sections' updates here
    // For example, show a dialog or print a message
    // ignore: avoid_print
    print('$section updated!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Settings', style: heading),
        backgroundColor: Colors.blue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
          children: [
            // Device Name Topic and Input Field
            Text(
              'Device Name',
              style: heading,
              textAlign: TextAlign.left, // Align text to the left
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: deviceNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Device Name',
                hintText: 'Enter device name',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => handleUpdateTap('Device Name'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0).copyWith(right: 100),
                child: Container(
                  width: 160, // Increased width
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical padding
                  alignment: Alignment.center, // Center align the "Update" text
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Update',
                    style: buttonTxt,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tank Control Levels Topic and Input Fields
            Text(
              'Water Control Levels',
              style: heading,
              textAlign: TextAlign.left, // Align text to the left
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: minLevelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Min Level',
                hintText: 'Enter min level',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: maxLevelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Max Level',
                hintText: 'Enter max level',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => handleUpdateTap('Water Control Levels'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0).copyWith(right: 100),
                child: Container(
                  width: 160, // Increased width
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical padding
                  alignment: Alignment.center, // Center align the "Update" text
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Update',
                    style: buttonTxt,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tank Measurements Topic and Input Fields
            Text(
              'Tank Measurements',
              style: heading,
              textAlign: TextAlign.left, // Align text to the left
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: capacityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Capacity',
                hintText: 'Enter capacity',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height',
                hintText: 'Enter height',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => handleUpdateTap('Tank Measurements'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0).copyWith(right: 100),
                child: Container(
                  width: 160, // Increased width
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical padding
                  alignment: Alignment.center, // Center align the "Update" text
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Update',
                    style: buttonTxt,
                  ),
                ),
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
    home: DeviceSettings(),
  ));
}
