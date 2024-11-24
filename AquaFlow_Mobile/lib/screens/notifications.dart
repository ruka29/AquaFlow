import 'package:flutter/material.dart';

import '../theme/theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // List of notifications
  List<String> notifications = [
    'Tank Overflowing!',
    'Automatic control turned Off',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title:  Text(
          'Notifications',
          style: heading,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'images/flavicon.png',
              height: 40.0,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Notifications List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notifications[index],
                          style: subText,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              notifications.removeAt(index);
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
