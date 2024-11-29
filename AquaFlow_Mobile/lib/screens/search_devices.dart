import 'package:aquaflow_mobile/screens/enter_wifi_details.dart';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/styles_&_fn_handle.dart';
import '../theme/theme.dart';

class SearchDevices extends StatefulWidget {
  const SearchDevices({super.key});

  @override
  State<SearchDevices> createState() => _SearchDevicesState();
}

class _SearchDevicesState extends State<SearchDevices> {
  List<WiFiAccessPoint> availableNetworks = [];
  String? errorMessage;
  bool isDeviceConnected = false;

  @override
  void initState() {
    super.initState();
    scanWifiNetworks();
  }

  Future<bool> requestPermissions() async {
    if (await Permission.location.isGranted &&
        (await Permission.nearbyWifiDevices.isGranted || await Permission.locationAlways.isGranted)) {
      return true;
    } else {
      await Permission.location.request();
      await Permission.nearbyWifiDevices.request();
      return Permission.location.isGranted;
    }
  }

  Future<void> scanWifiNetworks() async {
    final hasPermissions = await requestPermissions();
    if (!hasPermissions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Permissions not granted. Unable to scan Wi-Fi networks.'),
        ),
      );
      return;
    }

    try {
      final canScan = await WiFiScan.instance.canStartScan();
      if (canScan == CanStartScan.yes) {
        await WiFiScan.instance.startScan();

        WiFiScan.instance.onScannedResultsAvailable.listen((networks) {
          setState(() {
            availableNetworks = networks;
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Cannot start Wi-Fi scan. Turn on WIFI and Location.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }

  Future<bool> connectToAP(String ssid, String password) async {
    try {
      bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
      if (!isWifiEnabled) {
        await WiFiForIoTPlugin.setEnabled(true);
      }

      bool isConnected = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA,
      );

      if (isConnected) {
        debugPrint("Successfully connected to $ssid");
        return true;
      } else {
        debugPrint("Failed to connect to $ssid");
        return false;
      }
    } catch (e) {
      debugPrint("Error connecting to $ssid: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    void showConnectToAPDialog({
      required BuildContext context,
      required String ssid,
      required Function(String password) onConnect,
    }) {
      final TextEditingController passwordController = TextEditingController();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Text(
              "Connect to '$ssid'",
              style: const TextStyle(fontFamily: "Nunito-Bold", fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            content: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: input,
                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.black45),
                ),
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },

                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.grey[200],
                ),

                child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontFamily: 'Nunito-Bold',
                      fontSize: 15.0,
                      color: Colors.black,
                    )
                ),
              ),

              OutlinedButton(
                onPressed: () {
                  String password = passwordController.text;
                  if (password.isNotEmpty) {
                    Navigator.of(context).pop(); // Close the dialog
                    onConnect(password); // Pass the password to the callback
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Password cannot be empty."),
                      ),
                    );
                  }
                },

                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  side: BorderSide(
                    color: const Color(0xFF308EFF).withOpacity(0.2), // subtle border matching the button color
                    width: 1.0,
                  ),
                  backgroundColor: const Color(0xFF308EFF),
                ),

                child: const Text(
                    "Connect",
                    style: TextStyle(
                      fontFamily: 'Nunito-Bold',
                      fontSize: 15.0,
                      color: Colors.white,
                    )
                ),
              )
            ],
          );
        },
      );
    }

    void handleConnect(String ssid, BuildContext context) {
      showConnectToAPDialog(
        context: context,
        ssid: ssid,
        onConnect: (password) async {
          // Simulate the connection process (replace this with real functionality)
          bool isConnected = await connectToAP(ssid, password);

          if (isConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text("Connected to $ssid successfully!"),
              ),
            );
            Navigator.push(
              context,
              SlidePageRoute(
                page: const EnterWifiDetails(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text("Failed to connect to $ssid. Please try again."),
              ),
            );
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Device",
          style: TextStyle(
            fontFamily: "Nunito-Bold",
            fontSize: 23.0,
            color: Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 500.0,
                child: availableNetworks.isEmpty
                    ? const Center(
                        child: Text(
                          "Searching for devices...",
                          style: TextStyle(
                            fontFamily: "Nunito-Bold",
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : ListView.builder(
                      itemCount: availableNetworks.length,
                      itemBuilder: (context, index) {
                        final network = availableNetworks[index];
                        return ListTile(
                          leading: const Icon(Icons.wifi_password_rounded),
                          title: Text(network.ssid),
                          onTap: () => handleConnect(network.ssid, context),
                        );
                      },
                    ),
              ),
          
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Note:",
                    style: TextStyle(
                      fontFamily: "Nunito-Bold",
                      fontSize: 15.0,
                      color: Colors.red,
                    ),
                  ),
          
                  SizedBox(height: 5.0,),
          
                  Text(
                    "Make sure device is powered on and indicating red light.",
                    style: TextStyle(
                      fontFamily: "Nunito-Bold",
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                  ),
          
                  SizedBox(height: 5.0,),
          
                  Text(
                    "Allow WIFI and Location Permissions.",
                    style: TextStyle(
                      fontFamily: "Nunito-Bold",
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                  ),
          
                  SizedBox(height: 5.0,),
          
                  Text(
                    "Make sure your mobile has turned on WIFI and Location.",
                    style: TextStyle(
                      fontFamily: "Nunito-Bold",
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                  ),
          
                  SizedBox(height: 5.0,),
          
                  Text(
                    "Select device and enter password on the popup window. Then 'Connect'.",
                    style: TextStyle(
                      fontFamily: "Nunito-Bold",
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                  ),
          
                  SizedBox(height: 10.0,),
          
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       if(isDeviceConnected) {
                  //
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: isDeviceConnected ? primaryColor : Colors.grey,
                  //       minimumSize: const Size.fromHeight(50),
                  //       padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //     child:  Text(
                  //       'Continue',
                  //       style: buttonTxt,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
