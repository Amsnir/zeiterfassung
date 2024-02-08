// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/login/components/my_button.dart';
import 'package:zeiterfassung_v1/login/components/my_textfield.dart';
import 'package:zeiterfassung_v1/DnAuswahl.dart'; // Adjust the import path as necessary
// Adjust the import path to where your ApiService is located

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final serverController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> signUserIn() async {
  setState(() {
    _isLoading = true;
  });

  final success = await ApiHandler.getCookie(
    serverController.text,
    usernameController.text,
    passwordController.text,
  );

  if (success==true) {
    // Success: Navigate to DNAuswahlPage
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DNAuswahlPage()));
  } else {
    // Failure: Show an error message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed, please check your credentials and try again.')));
  }

  if (mounted) {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 75),
                  Image.asset(
                      'lib/images/LHR.png'), // Ensure your image path is correct
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: serverController,
                    hintText: 'Server URL: http://XXX.XXX.X.X:XXX',
                    obscureText: false,
                  ),
                  const SizedBox(height: 40),
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height: 40),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap:
                        signUserIn, // Ensure your MyButton widget supports onTap parameter
                  ),
                ],
              ),
            ),
    );
  }
}
