import 'dart:convert';

import 'package:auth/Screens/login.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _phone_numberController = TextEditingController();
  bool _isLoading = false;
  Future<dynamic> registerUser(Map<String, dynamic>? data) async {
    try {
      final response = await http.post(
        Uri.parse('http://129.154.238.127/api/register/'),
        body: data,
      );
      return json.decode(response.body);
    } catch (e) {
      print(e.toString());
      return null; // Return null if there is an error
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await registerUser({
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'password2': _confirmpasswordController.text,
        'phone_number': _phone_numberController.text
      });

      if (response != null &&
          response['Status'] == 200 &&
          response['response'] == 'data saved successfully') {
        // Registration failed, display error message
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', response['token']);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MyhomePage(),
        ));
      } else if (response == null) {
        // Registration successful, save auth token to shared preferences
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed'),
            backgroundColor: Colors.red,
          ),
        );

        // Navigate to home screen
      } else {
        // Registration failed, display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 80, left: 100),
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        "assets/images/user.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30, left: 10),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        controller: _usernameController,
                        decoration: InputDecoration(
                            labelText: 'Enter User Name',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon:
                                const Icon(Icons.emoji_emotions_outlined),
                            prefixIconColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your user name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'Enter Your Email',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(Icons.email),
                            prefixIconColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        controller: _phone_numberController,
                        decoration: InputDecoration(
                            labelText: 'Enter Your Phone Number',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.phone_android),
                            prefixIconColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Phone Number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        obscureText: _obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'Enter Password',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }),
                            prefixIconColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        obscureText: _obscureText,
                        controller: _confirmpasswordController,
                        decoration: InputDecoration(
                            labelText: 'Confirm your Password',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }),
                            prefixIconColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        validator: (value) {
                          if (value!.isEmpty ||
                              value != _passwordController.text) {
                            return 'Please Check your Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _submitForm,
                        child: const Text(
                          "Sign Up",
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, left: 50),
                          child: const Text(
                            "Already have an account ?",
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 70, top: 10),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ));
                            },
                            child: const Text(
                              "Login ",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
