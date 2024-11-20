import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Container with Settings title and image
          Container(
            height: 60.0,
            color: Colors.blue[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    'images/flavicon.png',
                    height: 60.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Gesture Area for Remove Device
          GestureDetector(
            onTap: () {
              //  Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const NavBarPage()),
              //     );
              // ignore: avoid_print
              print('Remove Device tapped');
            },
            child: const ListTile(
              leading: Icon(Icons.remove, color: Colors.red),
              title: Text(
                'Remove Device',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // Gesture Area for Logout
          GestureDetector(
            onTap: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
              // ignore: avoid_print
              print('Logout tapped');
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.blue),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
