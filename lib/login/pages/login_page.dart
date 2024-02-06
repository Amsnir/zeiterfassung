import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeiterfassung_v1/login/components/my_button.dart';
import 'package:zeiterfassung_v1/login/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final serverController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUserIn(BuildContext context) async {
    final url = Uri.parse('${serverController.text}/Self/login?username=${usernameController.text}&password=${passwordController.text}');
    try {
      final response = await http.get(url);

      if (response.headers['set-cookie'] != null) {
        final cookie = response.headers['set-cookie'];
        // Save the cookie for later use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cookie', cookie!);

        // Navigate to another page or show a success message
        // For example: Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Handle login failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed, please check your credentials and try again.')),
        );
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Image.asset('lib/images/LHR.png'),
          const SizedBox(),
          const Text(
            'Anmelden um fortzufahren!',
            style: TextStyle(
              color: Color.fromRGBO(240, 135, 45, 100),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          MyTextField(
            controller: serverController,
            hintText: 'Server URL: http://XXX.XXX.X.X:XXX',
            obscureText: false,
          ),
          const SizedBox(height: 40),
          MyTextField(
            controller: usernameController,
            hintText: 'example@exp.com',
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
            onTap: () => signUserIn(context),
          ),
        ],
      ),
    );
  }
}
