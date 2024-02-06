import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeiterfassung_v1/login/components/my_button.dart';
import 'package:zeiterfassung_v1/login/components/my_textfield.dart';

// Import your HomePage and other custom widgets
import 'package:zeiterfassung_v1/DnAuswahl.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

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

    final url = Uri.parse(
        '${serverController.text}/Self/login?username=${usernameController.text}&password=${passwordController.text}');

    try {
      final response = await http.get(url);

      // Example condition for successful login, adjust based on your API response
      if (response.statusCode == 200 &&
          response.headers['set-cookie'] != null) {
        final cookie = response.headers['set-cookie'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cookie', cookie!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '$cookie')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  DNAuswahlPage()), // Adjust this to your HomePage or the next page
        );
      } else {
        // Handle login failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Login failed, please check your credentials and try again.')),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Use SingleChildScrollView to avoid overflow when keyboard is visible
              child: Column(
                children: [
                  //Logo
                  const SizedBox(height: 75),
                  Image.asset('lib/images/LHR.png'),

                  //ServerURL
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: serverController,
                    hintText: 'Server URL: http://XXX.XXX.X.X:XXX',
                    obscureText: false,
                  ),

                  //Username
                  const SizedBox(height: 40),
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  //Password
                  const SizedBox(height: 40),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  //LoginButton
                  const SizedBox(height: 25),
                  MyButton(
                    onTap:
                        signUserIn, 
                  ),
                
                ],
              ),
            ),
    );
  }
}
