import 'dart:convert';

import 'package:aquaflow_mobile/screens/device_details.dart';
import 'package:aquaflow_mobile/screens/notifications.dart';
import 'package:aquaflow_mobile/screens/search_devices.dart';
import 'package:aquaflow_mobile/services/device_controller.dart';
import 'package:aquaflow_mobile/services/secure_storage_helper.dart';
import 'package:aquaflow_mobile/theme/theme.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../services/styles_&_fn_handle.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

Future<Map<String, dynamic>?> fetchUserData() async {
  final token = await SecureStorageHelper.getToken();
  if (token == null) {
    print("No token found");
    return null;
  }

  final response = await http.post(
    Uri.parse('https://5fjm2w12-5000.asse.devtunnels.ms/api/auth/user'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return Map<String, dynamic>.from(json.decode(response.body));
  } else {
    print('Failed to fetch user data: ${response.body}');
    return null;
  }
}

class _MainPageState extends State<MainPage> {
  Map<String, dynamic>? userData;
  late WebSocketChannel channel;
  String userId = "";
  String receivedMessage = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
    connectToWebSocket();
  }

  Future<void> loadUserData() async {
    final data = await fetchUserData();
    if (data != null) {
      setState(() {
        userData = data;
        userId = userData!['_id'];
      });
      print(userId);
      print(userData);
    }
  }

  void connectToWebSocket() {
    final webSocketUrl = "ws://5fjm2w12-5000.asse.devtunnels.ms:3000?userId=$userId";
    channel = WebSocketChannel.connect(Uri.parse(webSocketUrl));

    // Listen for messages
    channel.stream.listen(
          (message) {
        setState(() {
          receivedMessage = message;
        });
        print("Message from server: $message");
      },
      onError: (error) {
        print("WebSocket error: $error");
      },
      onDone: () {
        print("WebSocket connection closed");
      },
    );
  }

  @override
  void dispose() {
    // Close the WebSocket connection
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      alwaysShowLeadingAndAction: true,
      floatingActionButton: OutlinedButton(
        onPressed: () => loadUserData(),

        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          side: BorderSide(
            color: const Color(0xFF308EFF).withOpacity(0.2), // subtle border matching the button color
            width: 1.0,
          ),
          backgroundColor: const Color(0xFF308EFF),
        ),

        child: const Icon(
          Icons.refresh_rounded,
          color: Colors.white,
          size: 15.0,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const NotificationsPage(),
            ),
          );
        },
        icon: const Icon(Icons.menu_rounded),
        color: Colors.black,
      ),
      title: Image.asset(
        "images/AquaFlow_name.png",
        width: 150.0,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                SlidePageRoute(
                  page: const NotificationsPage(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_active_outlined),
            color: Colors.black,
          ),
        ),
      ],
      headerWidget: headerWidget(context),
      body: [
        container()
      ],
      fullyStretchable: true,
      backgroundColor: Colors.white,
      appBarColor: Colors.lightBlue[100],
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      color: Colors.lightBlue[100],
      child: Center(
        child:Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
          child: Image.asset(
            "images/AquaFlow_logo2.png",
            // height: 250.0,
            // width: 250.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Container container() {
    return Container(
      child: userData == null ?
      const Padding(
        padding: EdgeInsets.only(top: 100.0),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "Welcome, ${userData!['name']}!",
              style: const TextStyle(
                fontFamily: "Nunito-Bold",
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),
            ),
          ),

          const SizedBox(height: 20.0,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Devices",
                  style: TextStyle(
                    fontFamily: "Nunito-Bold",
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),

                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      SlidePageRoute(
                        page: const SearchDevices(),
                      ),
                    );
                  },

                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(
                      color: const Color(0xFF308EFF).withOpacity(0.2), // subtle border matching the button color
                      width: 1.0,
                    ),
                    backgroundColor: const Color(0xFF308EFF),
                  ),

                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15.0,
                  ),

                  label: const Text(
                      "Add Device",
                      style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontSize: 15.0,
                        color: Colors.white,
                      )
                  ),
                )
              ],
            ),
          ),

          // Conditional rendering based on userData
          userData == null
              ? const Center(
                  child: CircularProgressIndicator(), // Show loading indicator
                )
                    : userData!['devices'].isEmpty
                    ? const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "No devices found.",
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                    )
                        : ListView.builder(
                          shrinkWrap: true, // Avoid unnecessary scrolling
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: userData!['devices'].length,
                          itemBuilder: (context, index) {
                            final device = userData!['devices'][index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12.0),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        SlidePageRoute(
                                          page: DeviceDetailsPage(macAddress: device['macAddress']),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                device['deviceName'] ?? 'Unknown Device',
                                                style: const TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 3.0),
                                              Text(
                                                device['status'] ?? 'offline',
                                                style: TextStyle(
                                                  fontFamily: "Nunito-Bold",
                                                  fontSize: 12.0,
                                                  color: device['status'] == 'online'
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              const SizedBox(height: 7.0),
                                              Text(
                                                "Water Level: ${device['waterLevel'] ?? 'N/A'}%",
                                                style: const TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Switch(
                                            activeColor: primaryColor,
                                            thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                                                  (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.selected)) {
                                                  return const Icon(
                                                    Icons
                                                        .power_settings_new_rounded,
                                                    color: Colors.white,
                                                  );
                                                }
                                                return const Icon(
                                                  Icons
                                                      .power_settings_new_rounded,
                                                  color: primaryColor,
                                                );
                                              },
                                            ),
                                            trackOutlineColor:
                                            MaterialStateProperty.all(primaryColor),
                                            trackOutlineWidth:
                                            MaterialStateProperty.all(1),
                                            value: device['valveState'] ?? false,
                                            onChanged: (value) async {
                                              setState(() {
                                                device['valveState'] = value;
                                              });
                                              try {
                                                final response = await DeviceController.controlValve(device['macAddress'], value);

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
                                                    device['valveState'] = !value;
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
                                                  device['valveState'] = !value;
                                                });

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text('Error controlling valve: $e'),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                    ),
        ],
      ),
    );
  }
}
