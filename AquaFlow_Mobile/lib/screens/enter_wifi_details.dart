import 'dart:convert';

import 'package:aquaflow_mobile/screens/change_device_name.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/secure_storage_helper.dart';
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

  Future<bool> sendDetailsToDevice(String ssid, String password) async {
    try {
      final token = await SecureStorageHelper.getToken();
      if (token == null) {
        print("No token found");
        return false;
      }

      final deviceUrl = Uri.parse('http://192.168.4.1/connect-wifi');
      final body = json.encode({
        "SSID": ssid,
        "password": password,
        "token": token,
      });

      final response = await http.post(
        deviceUrl,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        print("Wi-Fi details sent successfully.");
        return true;
      } else {
        print("Failed to send Wi-Fi details: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending Wi-Fi details: $e");
      return false;
    }
  }

  void sendWifiDetails() async {
    setState(() {
      _isLoading = true;
    });

    String ssid = _ssidController.text;
    String password = _passwordController.text;

    if (ssid.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('SSID and Password are required!'),
        ),
      );
      return;
    }

    bool success = await sendDetailsToDevice(ssid, password);
    if (success) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Wi-Fi details sent successfully!'),
        ),
      );
      Navigator.push(
        context,
        SlidePageRoute(
          page: const ChangeDeviceName(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to send Wi-Fi details. Try again!'),
        ),
      );
    }
  }

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
                        onPressed: () => sendWifiDetails(),
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
