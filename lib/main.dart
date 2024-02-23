import 'package:flutter/material.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';
import 'package:zeiterfassung_v1/login/pages/login_page.dart';
import 'package:zeiterfassung_v1/DNAuswahl.dart';

void main() async {
  await HiveFactory.initHive();
  await HiveFactory.registerAdapter();
  WidgetsFlutterBinding.ensureInitialized();
  //synchData();

  runApp(const MainApp());

  // After runApp, check connectivity and process offline bookings
  processOfflineBuchungenIfNeeded();
}

Future<void> processOfflineBuchungenIfNeeded() async {
  // Check for connectivity
  bool isConnected = await ApiHandler.checkConnectivity();
  if (isConnected) {
    await sendOfflineBuchungenToServer();
  }
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: ApiHandler.checkConnectivity(), // Your checkConnectivity method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the future is complete and data is available, use it to decide the initial route
            if (snapshot.data == true) {
              // If checkConnectivity returns true, navigate to LoginPage
              return const LoginPage();
            } else {
              // If checkConnectivity returns false, navigate to DNAuswahlPage
              return DNAuswahlPage(); // Make sure this is the correct name and it's imported
            }
          } else {
            // While waiting for the future to complete, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
