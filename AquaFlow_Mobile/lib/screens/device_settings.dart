import 'package:flutter/material.dart';

import '../theme/theme.dart';

class DeviceSettings extends StatefulWidget {
  const DeviceSettings({super.key});

  @override
  State<DeviceSettings> createState() => _DeviceSettingsState();
}

class _DeviceSettingsState extends State<DeviceSettings> {
  @override
  Widget build(BuildContext context) {
    void changeDeviceName({
      required BuildContext context,
      required String name,
      required Function(String password) onConnect,
    }) {
      final TextEditingController nameController = TextEditingController();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Text(
              "Change Device Name",
              style: const TextStyle(fontFamily: "Nunito-Bold", fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            content: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: name,
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
                  String name = nameController.text;
                  if (name.isNotEmpty) {
                    Navigator.of(context).pop(); // Close the dialog
                    onConnect(name); // Pass the password to the callback
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
                    "Save",
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

    void handleChangeName(String name, BuildContext context) {
      changeDeviceName(
        context: context,
        name: name,
        onConnect: (password) async {


          // if (isConnected) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       backgroundColor: Colors.green,
          //       content: Text("Device name changed successfully!"),
          //     ),
          //   );
          //   // Navigator.push(
          //   //   context,
          //   //   SlidePageRoute(
          //   //     page: const EnterWifiDetails(),
          //   //   ),
          //   // );
          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       backgroundColor: Colors.red,
          //       content: Text("Failed to change device name. Please try again."),
          //     ),
          //   );
          // }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontFamily: "Nunito-Bold",
            fontSize: 23.0
          ),
        ),
      ),

      body: const  Padding(
        padding: EdgeInsets.only(left:  15.0, top: 10.0, right: 15.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Device name",
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),

                Row(
                  children: [
                    Text(
                      "Main Water Tank",
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 15.0,
                        color: Colors.grey
                      ),
                    ),

                    SizedBox(width: 5.0,),

                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 18.0,
                    )
                  ],
                )
              ],
            ),

            SizedBox(height: 5.0,),

            Divider(
              color: Colors.grey,
            ),

            SizedBox(height: 5.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Max Water Level",
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    SizedBox(height: 5.0,),

                    Text(
                      "Min Water Level",
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "90%",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 15.0,
                            color: Colors.grey
                          ),
                        ),

                        SizedBox(height: 8.0,),

                        Text(
                          "20%",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 15.0,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 5.0,),

                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 18.0,
                    )
                  ],
                ),
              ],
            ),

            SizedBox(height: 5.0,),

            Divider(
              color: Colors.grey,
            ),

            SizedBox(height: 5.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tank Capacity",
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    SizedBox(height: 5.0,),

                    Text(
                      "Tank Height",
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "1000 L",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 15.0,
                            color: Colors.grey
                          ),
                        ),

                        SizedBox(height: 8.0,),

                        Text(
                          "1 m",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 15.0,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 5.0,),

                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 18.0,
                    )
                  ],
                ),
              ],
            ),

            SizedBox(height: 5.0,),

            Divider(
              color: Colors.grey,
            ),

            SizedBox(height: 5.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Remove Device",
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 18.0,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
