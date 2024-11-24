import 'package:flutter/material.dart';

class DeviceSettings extends StatefulWidget {
  const DeviceSettings({super.key});

  @override
  State<DeviceSettings> createState() => _DeviceSettingsState();
}

class _DeviceSettingsState extends State<DeviceSettings> {
  @override
  Widget build(BuildContext context) {
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
