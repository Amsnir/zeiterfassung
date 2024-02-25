import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/login/components/my_button.dart';
import 'package:zeiterfassung_v1/login/components/my_textfield.dart';
import 'package:zeiterfassung_v1/DnAuswahl.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/offlinebuchung.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

class LoginPage extends StatefulWidget {
  final int initialProcessedBookingsCount;

  const LoginPage({Key? key, this.initialProcessedBookingsCount = 0})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final serverController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  int _processedBuchungenCount = 0;
  bool _isLoading = false;
  final storage = const FlutterSecureStorage(); // Secure storage instance
  bool _saveLoginInfo = false; // Checkbox state

  @override
  void initState() {
    super.initState();
    loadCredentials();
    if (widget.initialProcessedBookingsCount > 0) {
      // Wait for the widget to build before showing the dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        promptUserForOfflineBuchungen(widget.initialProcessedBookingsCount);
      });
    }
  }

  Future<void> loadCredentials() async {
    final serverUrl = await storage.read(key: 'serverUrl');
    final username = await storage.read(key: 'username');
    final password = await storage.read(key: 'password');

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

  Future<void> promptUserForOfflineBuchungen(int count) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Offline Buchungen'),
          content: Text(
              'Sie haben $count ausstehende Buchungen. Möchten Sie diese jetzt senden?'),
          actions: <Widget>[
            TextButton(
              child: Text('Verwerfen'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: () =>
                  Navigator.of(context).pop(false), // Return false on cancel
            ),
            TextButton(
              child: Text('Senden'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Color(0xFF443B5A)),
              ),
              onPressed: () =>
                  Navigator.of(context).pop(true), // Return true on send
            ),
          ],
        );
      },
    );

    // Act based on the dialog result
    if (result == true) {
      // User chooses to send the bookings
      int processedCount = await ApiHandler().sendOfflineBuchungenToServer();
      notifyUserOfProcessedBuchungen(processedCount);
    } else {
      // User chooses not to send the bookings
      deleteAllOfflineBuchungen();
    }
  }

  Future<void> deleteAllOfflineBuchungen() async {
    Box<Buchungen> box = await HiveFactory.openBox<Buchungen>('offlinebuchung');
    await box.clear(); // This deletes all entries in the box
    // Optionally, notify the user that the bookings have been deleted
  }

  void notifyUserOfProcessedBuchungen(int count) {
    setState(() {
      _processedBuchungenCount = count;
    });
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
    // Determine if the device is in landscape mode
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (_processedBuchungenCount >
                      0) // Display only if there are processed bookings
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          '$_processedBuchungenCount ausstehende Buchung(en) versendet',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                    ),
                  const SizedBox(height: 75),
                  Image.asset(
                    'lib/images/LHR.png',
                    width: isLandscape
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.cover,
                  ),
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
                    title: const Text("Anmeldedaten merken"),
                    value: _saveLoginInfo,
                    onChanged: (bool? value) {
                      setState(() {
                        _saveLoginInfo = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap: signUserIn,
                  ),
                ],
              ),
            ),
    );
  }
}
