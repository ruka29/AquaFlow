import 'package:flutter/material.dart';
import 'package:mobile/screens/signup.dart';
import 'package:mobile/theme.dart'; // Ensure this file contains the definition for `superHeading`.

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding for better layout
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo image at the top
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
                  'Manage your life better with AquaFlow.',
                  textAlign: TextAlign.center,
                  style: subHeading,
                   // Ensure this is defined in `theme.dart`.
                ),
              ),
              const SizedBox(height: 30),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                'Upgrade your water management with our automated water tank level measuring and controlling system! Real-time water level updates and ensures your tank never overflows',                  textAlign: TextAlign.center,
                  style: text,
                   // Ensure this is defined in `theme.dart`.
                ),
              ),
              const SizedBox(height: 30),
              

              // Image below the description
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'images/home_image.png', // Path to the image
                  width: 500,
                  fit: BoxFit.cover,
                ),
              ),

              // "Get Started" button
              ElevatedButton(
                onPressed: () {
                  // Navigate to the SignUpPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Dark blue color
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical:18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'GET STARTED >>',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Montserrat"),
                ),
              ),
              const SizedBox(height: 70), // Bottom spacing
            ],
          ),
        ),
      ),
    );
  }
}
