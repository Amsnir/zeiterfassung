import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/login/components/my_button.dart';
import 'package:zeiterfassung_v1/login/components/my_textfield.dart';
import 'package:zeiterfassung_v1/DnAuswahl.dart'; // Adjust the import path as necessary

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
  final storage = FlutterSecureStorage(); // Secure storage instance
  bool _saveLoginInfo = false; // Checkbox state

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  Future<void> loadCredentials() async {
    final serverUrl = await storage.read(key: 'serverUrl');
    final username = await storage.read(key: 'username');
    final password = await storage.read(key: 'password');

    // Consider not loading the password for enhanced security
    // and prompt the user to enter it each time

    // Load credentials if available
    if (serverUrl != null && username != null && password != null) {
      setState(() {
        serverController.text = serverUrl;
        usernameController.text = username;
        passwordController.text = password;
        _saveLoginInfo = true;
      });
    }
  }

  Future<void> signUserIn() async {
    setState(() {
      _isLoading = true;
    });

    final success = await ApiHandler.getCookie(
      serverController.text,
      usernameController.text,
      passwordController.text,
    );

    if (success == true) {
      if (_saveLoginInfo) {
        // Save credentials
        await storage.write(key: 'serverUrl', value: serverController.text);
        await storage.write(key: 'username', value: usernameController.text);
        await storage.write(
            key: 'password',
            value: passwordController.text); // Storing the password securely
      } else {
        // Clear saved credentials if the user opts out
        await storage.delete(key: 'serverUrl');
        await storage.delete(key: 'username');
        await storage.delete(key: 'password');
      }

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DNAuswahlPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Login failed, please check your credentials and try again.')));
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
                    hintText: 'http://XXX.XXX.X.X:XXX',
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
                  CheckboxListTile(
                    title: Text("Anmeldedaten merken"),
                    value: _saveLoginInfo,
                    onChanged: (bool? value) {
                      setState(() {
                        _saveLoginInfo = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, // Position the checkbox at the start of the tile
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
