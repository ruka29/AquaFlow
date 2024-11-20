import 'package:flutter/material.dart';
import 'package:mobile/screens/home.dart';
import 'package:mobile/screens/signup.dart';
import 'package:mobile/theme.dart'; // Assuming the theme file contains 'primaryColor', 'input', etc.

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo at the top
              Image.asset(
                'images/AquaFlow_logo.png',
                width: 350,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 14),

              // Title text
               Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: blueHeading,
              ),
               const SizedBox(height: 20),
                 Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'images/save_water.png', 
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
        

             
              const SizedBox(height: 20),

              // Email TextFormField
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: input,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password TextFormField
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: input,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                ),
              ),
              const SizedBox(height: 42),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:  Text(
                  'Log In',
                  style:buttonTxt,
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
                      'OR LOGIN WITH',
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

              // Google Login Button
              OutlinedButton.icon(
                onPressed: () {
                  // Add functionality for Google login
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: BorderSide.none,
                  backgroundColor: Colors.grey[200],
                ),
                icon: Image.asset(
                  'images/google_logo.png',
                  width: 40,
                  height: 40,
                ),
                label: const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),

              // Sign Up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account? ',
                    style: subText,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
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
             
            ],
          ),
        ),
      ),
    );
  }
}
