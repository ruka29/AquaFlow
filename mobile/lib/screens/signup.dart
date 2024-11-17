import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
              // Logo at the top
              Image.asset(
                'images/AquaFlow_logo.png',
                width: 250,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20),

              // Title text
              Text(
                'Create Your AquaFlow Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),

              // Email TextField
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),

              // Password TextField
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),

              // Google signup button
              OutlinedButton.icon(
                onPressed: () {
                  // Add functionality for Google signup
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  side: BorderSide(color: Colors.blue[800]!, width: 2),
                ),
                icon: Image.asset(
                  'images/google_logo.png', // Path to Google logo image
                  width: 24,
                  height: 24,
                ),
                label: Text(
                  'Sign Up with Google',
                  style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                ),
              ),
              const SizedBox(height: 30),

              // Sign Up button
              ElevatedButton(
                onPressed: () {
                  // Add navigation or functionality for signing up
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Login link below the button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                     Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const  LoginPage()),
                  );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w600,
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
