import 'package:flutter/material.dart';
import 'package:mobile/screens/signup.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for better layout
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image at the top
              Image.asset(
                'images/AquaFlow_logo.png',
                width: 350,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20),

              // Description text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Manage water better with AquaFlow. Every drop counts! Enjoy your life with peace while saving for good.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue[900], // Dark blue for description text
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Image below the button, centered and slightly larger
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'images/home_image.png', // Replace with the path to the new image
                  width: 500,
                  fit: BoxFit.cover,
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  // Navigate to the SignUpPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800], // Dark blue
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'GET STARTED >>',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
