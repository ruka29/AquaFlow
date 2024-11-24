import 'package:aquaflow_mobile/screens/device_details.dart';
import 'package:aquaflow_mobile/screens/notifications.dart';
import 'package:aquaflow_mobile/screens/search_devices.dart';
import 'package:aquaflow_mobile/theme/theme.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

import '../services/styles_&_fn_handle.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      alwaysShowLeadingAndAction: true,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              "Welcome, Rukshan!",
              style: TextStyle(
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
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
                        page: const DeviceDetailsPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the left
                          children: [
                            Text(
                              "Main Water Tank",
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),

                            SizedBox(height: 3.0,),

                            Text(
                              "Online",
                              style: TextStyle(
                                  fontFamily: "Nunito-Bold",
                                  fontSize: 12.0,
                                  color: Colors.green
                              ),
                            ),

                            SizedBox(height: 7.0,),

                            Text(
                              "Water Level: 25% (250L)",
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: 15.0,
                                  color: Colors.black
                              ),
                            )
                          ],
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
                          value: false,
                          onChanged: (value) {
                            setState(() {
                              var waterValueSwitch = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
