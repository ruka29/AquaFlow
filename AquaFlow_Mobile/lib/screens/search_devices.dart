import 'package:aquaflow_mobile/screens/enter_wifi_details.dart';
import 'package:flutter/material.dart';

import '../services/styles_&_fn_handle.dart';
import '../theme/theme.dart';

class SearchDevices extends StatefulWidget {
  const SearchDevices({super.key});

  @override
  State<SearchDevices> createState() => _SearchDevicesState();
}

class _SearchDevicesState extends State<SearchDevices> {
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 500.0,
              child: const SingleChildScrollView(
                child: Center(
                  child: Text(
                    "Searching for devices...",
                    style: TextStyle(
                      fontFamily: "Nunito-Bold",
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Note:",
                  style: TextStyle(
                    fontFamily: "Nunito-Bold",
                    fontSize: 15.0,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 5.0,),

                const Text(
                  "Make sure device is powered on and indicating red light.",
                  style: TextStyle(
                    fontFamily: "Nunito-Bold",
                    fontSize: 13.0,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 5.0,),

                const Text(
                  "Make sure your mobile has turned on WIFI.",
                  style: TextStyle(
                    fontFamily: "Nunito-Bold",
                    fontSize: 13.0,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 5.0,),

                const Text(
                  "Select device and enter password on the popup window. Then 'Connect'.",
                  style: TextStyle(
                    fontFamily: "Nunito-Bold",
                    fontSize: 13.0,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10.0,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        SlidePageRoute(
                          page: const EnterWifiDetails(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size.fromHeight(50),
                      padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:  Text(
                      'Continue',
                      style: buttonTxt,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
