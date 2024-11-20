import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/theme.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Spacious padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo at the top
              Image.asset(
                'images/AquaFlow_logo.png',
                width: 350,
                fit: BoxFit.fill,
                
              ),
              const SizedBox(height: 24),

              // Title text
               Text(
                'Create Your Account',
                textAlign: TextAlign.center,
                style: blueHeading,
              ),
              const SizedBox(height: 26),

              // Subtitle text
              Text(
                'Join AquaFlow today and take control of your water management!',
                textAlign: TextAlign.center,
                 style: heading
              ),
              const SizedBox(height: 32),

              // Email TextFormField
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: input,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45), // Underline color
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45), // Focused underline color
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password TextFormField
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: input,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45), // Underline color
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45), // Focused underline color
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 42),

              ElevatedButton(
                onPressed: () {
                  // Add navigation or functionality for signing up
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Dark blue color
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:  Text(
                  'SIGN UP',
                  style: buttonTxt,
                ),
              ),
              const SizedBox(height: 36),

              // Divider (OR Section)
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'OR SIGN UP WITH',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // Google Sign Up button
              OutlinedButton.icon(
                onPressed: () {
                  // Add functionality for Google signup
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: BorderSide.none, // Removed border color
                  backgroundColor: Colors.grey[200], // Light gray background
                ),
                icon: Image.asset(
                  'images/google_logo.png', // Path to Google logo image
                  width: 40,
                  height: 40,
                ),
                label: const SizedBox.shrink(), // Added label to satisfy syntax
              ),
              const SizedBox(height: 24),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: subText,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),

                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
