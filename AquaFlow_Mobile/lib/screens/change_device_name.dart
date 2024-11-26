import 'package:aquaflow_mobile/screens/main_page.dart';
import 'package:flutter/material.dart';

import '../services/styles_&_fn_handle.dart';
import '../theme/theme.dart';

class ChangeDeviceName extends StatefulWidget {
  const ChangeDeviceName({super.key});

  @override
  State<ChangeDeviceName> createState() => _ChangeDeviceNameState();
}

class _ChangeDeviceNameState extends State<ChangeDeviceName> {
  final TextEditingController _deviceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 60.0, right: 15.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  "Change Device Name.",
                  style: TextStyle(
                    fontFamily: "Nunito-Bold",
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: _deviceNameController,
                    decoration: InputDecoration(
                      labelText: 'Device Name',
                      labelStyle: input,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                    ),
                  ),
                ),
              ],
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
                  "Default min and max water level values are set to 20% and 90%.",
                  style: TextStyle(
                    fontFamily: "Nunito-Bold",
                    fontSize: 13.0,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 5.0,),

                const Text(
                  "To change go to 'Main Screen' > 'Device' > 'Settings' >",
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
                      Navigator.of(context).pushAndRemoveUntil(
                        SlidePageRoute(page: const MainPage()),
                            (Route<dynamic> route) => false,
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
            )
          ],
        ),
      ),
    );
  }
}
