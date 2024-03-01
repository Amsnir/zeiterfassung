import 'package:flutter/material.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';
import 'package:zeiterfassung_v1/login/pages/login_page.dart';
import 'package:zeiterfassung_v1/DNAuswahl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure plugins are initialized
  await HiveFactory.initHive(); // Initialize Hive
  await HiveFactory.registerAdapter(); // Register Hive adapters

  runApp(const MainApp());
}

Future<int> countOfflineBuchungen() async {
  bool isConnected = await ApiHandler.checkConnectivity();
  if (isConnected) {
    int offlineCount = await ApiHandler
        .countOfflineBookings(); // obtain count from your storage;
    return offlineCount;
  }
  return 0;
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("lib/images/LHR.png"), context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: ApiHandler.checkConnectivity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Navigate based on connectivity
            if (snapshot.data == true) {
              // If there's connectivity, navigate to LoginPage and then process offline Buchung
              WidgetsBinding.instance.addPostFrameCallback((_) {
                countOfflineBuchungen().then((count) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        LoginPage(initialProcessedBookingsCount: count),
                  ));
                });
              });
            } else {
              // No connectivity, go straight to DNAuswahlPage
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => DNAuswahlPage()));
              });
            }
            return Container(); // Placeholder widget until navigation completes
          } else {
            // While waiting, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
