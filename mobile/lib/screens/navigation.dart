import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/screens/tabs/home.dart';
import 'package:mobile/screens/tabs/notifications.dart';
import 'package:mobile/screens/tabs/settings.dart';

// Enum for selected tabs
enum _SelectedTab { settings, home, notifications }

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  _SelectedTab _selectedTab = _SelectedTab.home;

  // Method to get the corresponding page for the selected tab
  Widget _getPage(_SelectedTab tab) {
    switch (tab) {
      
      case _SelectedTab.settings:
        return const SettingsPage();
      case _SelectedTab.home:
        return const HomePage();
      case _SelectedTab.notifications:
        return const NotificationsPage();
      default:
        return const HomePage();
    }
  }

  // Method to handle navigation index changes
  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _getPage(_selectedTab),
        bottomNavigationBar: CustomNavigationBar(
          selectedColor: Colors.blueAccent,
          unSelectedColor: Colors.grey,
          strokeColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          onTap: _handleIndexChanged,
          items: [
          
            CustomNavigationBarItem(
              // ignore: deprecated_member_use
              icon: const FaIcon(FontAwesomeIcons.cogs),
              title: const Text('Settings'),
            ),
              CustomNavigationBarItem(
              // ignore: deprecated_member_use
              icon: const FaIcon(FontAwesomeIcons.home),
              title: const Text('Home'),
            ),
            CustomNavigationBarItem(
              icon: const FaIcon(FontAwesomeIcons.bell),
              title: const Text('Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const NavBarPage());
}
