import 'dart:convert';
import 'package:aquaflow_mobile/services/toggle_screens.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:aquaflow_mobile/theme/theme.dart';
import 'package:aquaflow_mobile/screens/sign_in.dart';

import '../services/secure_storage_helper.dart';
import '../services/styles_&_fn_handle.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
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

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  String userId = "";
  String receivedMessage = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Image.asset(
          'images/AquaFlow_logo.png', // Ensure the asset is added in pubspec.yaml
          width: 150,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: userData == null ?
          const Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ) : Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'Hassle-Free Water Management',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const SizedBox(height: 16),
              Text(
                'On Your Phone',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Wrap all ListTiles in one container with light grey background
              Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 239, 239, 239),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: primaryColor),
                      title: Text(
                        'Username: ${userData!['name']}',
                        style: input,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email, color: primaryColor),
                      title: Text(
                        'Email: ${userData!['email']}',
                        style: input,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        'Logout',
                        style: input,
                      ),
                      onTap: () {
                        SecureStorageHelper.deleteToken();
                        Navigator.of(context).pushAndRemoveUntil(
                          SlidePageRoute(page: const ToggleScreens()),
                              (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
