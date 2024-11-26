import 'package:aquaflow_mobile/screens/change_device_name.dart';
import 'package:flutter/material.dart';

import '../services/styles_&_fn_handle.dart';
import '../theme/theme.dart';

class EnterWifiDetails extends StatefulWidget {
  const EnterWifiDetails({super.key});

  @override
  State<EnterWifiDetails> createState() => _EnterWifiDetailsState();
}

class _EnterWifiDetailsState extends State<EnterWifiDetails> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Enter your WIFI credentials.",
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
                        controller: _ssidController,
                        decoration: InputDecoration(
                          labelText: 'SSID',
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

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                      "Make sure green light blinking twice a second.",
                      style: TextStyle(
                        fontFamily: "Nunito-Bold",
                        fontSize: 13.0,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 5.0,),

                    const Text(
                      "Enter your WIFI credentials, Then 'Continue'.",
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
                              page: const ChangeDeviceName(),
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
                )
              ],
            ),
          ),
          if(_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
