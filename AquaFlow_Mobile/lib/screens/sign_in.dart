import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/styles_&_fn_handle.dart';
import '../theme/theme.dart';
import 'main_page.dart';

class SignIn extends StatefulWidget {
  final VoidCallback showSignUpPage;
  const SignIn({super.key, required this.showSignUpPage});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  final _secureStorage = const FlutterSecureStorage();

  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
  }

  void clearFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://localhost:5000/api/auth/login');
    final body = json.encode({
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        print("Token: $token");

        await storeToken(token);

        clearFields();

        Navigator.of(context).pushAndRemoveUntil(
          SlidePageRoute(page: const MainPage()),
              (Route<dynamic> route) => false,
        );
      } else {
        // Handle errors
        final error = json.decode(response.body);
        print('Error: ${error['message']}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("${error['message']}"),
          ),
        );
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 150),

                  Image.asset(
                      "images/AquaFlow_logo2.png"
                  ),

                  const SizedBox(height: 50),

                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: blueHeading,
                  ),

                  const SizedBox(height: 30),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
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

                      const SizedBox(height: 20),

                      TextFormField(
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

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          _signIn();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: const Size.fromHeight(50),
                          padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:  Text(
                          'SIGN IN',
                          style: buttonTxt,
                        ),
                      ),

                      const SizedBox(height: 20),

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
                              'OR',
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

                      const SizedBox(height: 20),

                      // Google Sign Up button
                      OutlinedButton.icon(
                        onPressed: () {
                          // Add functionality for Google signup
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          side: BorderSide.none,
                          backgroundColor: Colors.grey[200],
                        ),
                        icon: Image.asset(
                          'images/google_logo.png',
                          width: 30,
                        ),
                        label: const Text(
                            "Sign in with Google",
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 17.0,
                              color: Colors.black,
                            )
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login link
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: subText,
                                ),

                                TextSpan(
                                  text: "Sign Up",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'Nunito-Bold',
                                    color: primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = widget.showSignUpPage,
                                )
                              ]
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
