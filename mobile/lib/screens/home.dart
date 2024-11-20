import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/screens/notifications.dart';
import 'package:mobile/screens/device_details.dart';  // Import the DeviceDetails page
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/theme.dart';
import 'package:switcher_button/switcher_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int waterLevelLiters = 520; // Water level in liters
  bool waterValueSwitch = true; // Water value switch state
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Image.asset(
          'images/AquaFlow_logo.png', // Replace with your image asset path
          height: 80.0,
          fit: BoxFit.fill,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0), // Add padding inside the container
            child: Row(
              children: [
                const SizedBox(width: 10),
                IconButton(
                icon: const FaIcon(FontAwesomeIcons.bell),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          // Use the image as the background for the DrawerHeader
          image: DecorationImage(
            image: AssetImage('images/drawer_cover.png'), // Path to your image
            fit: BoxFit.cover, // Ensures the image covers the area
          ),
        ),
        child: null, // No child, just the image
      ),
      ListTile(
           leading: const FaIcon(FontAwesomeIcons.user),
        title: Text('Username: John Peterson', style: input),
      ),
      ListTile(
          leading: const FaIcon(FontAwesomeIcons.envelope),
        title:  Text('Email: 7238@gmail.com', style: input,),
      ),
      const Divider(),
      ListTile(
        // ignore: deprecated_member_use
        leading: const FaIcon(FontAwesomeIcons.signOutAlt, color: secondaryColor),
        title:  Text('Logout', style: logout,),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
    ],
  ),
),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Add padding for all content below the app bar
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting Section
                   Text(
                    'David Peris',
                    style: heading
                  ),
                  const SizedBox(height: 20),
                  // Add Device Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      _showAddDeviceDialog();
                    },
                    icon: const Icon(Icons.add),
                    label:  Text(
                      'Add Device',
                      style: subHeading,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  // Device Card (Wrap it in GestureDetector for click functionality)
                  GestureDetector(
                    onTap: () {
                      // Navigate to DeviceDetails page on tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  const DeviceDetails()), // Navigate here
                      );
                    },
                    
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            'XYZ1245',
                            style:deviceName
                              
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Water Level: $waterLevelLiters L',
                            style:input,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Water Value',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Column(
                                children: [
                                  SwitcherButton(
                                    value: waterValueSwitch,
                                    onChange: (value) {
                                      setState(() {
                                        waterValueSwitch = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    waterValueSwitch ? 'ON' : 'OFF',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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

  // Method to show the Add Device Dialog
  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            'Add Device',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: deviceNameController,
                decoration: const InputDecoration(
                  labelText: 'Device Name',
                  hintText: 'Enter Device Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  hintText: 'Enter Capacity in Liters',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height',
                  hintText: 'Enter Height in cm',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // You can handle the logic to add the device here
                String deviceName = deviceNameController.text;
                // ignore: unused_local_variable
                String capacity = capacityController.text;
                // ignore: unused_local_variable
                String height = heightController.text;

                // Add the device (you can process this data as required)

                // Close the dialog
                Navigator.of(context).pop();

                // Optionally, clear the input fields
                deviceNameController.clear();
                capacityController.clear();
                heightController.clear();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
