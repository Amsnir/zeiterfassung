import 'package:flutter/material.dart';
import 'package:zeiterfassung_v1/dynamicbuttonswidget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';

class DNAuswahlPage extends StatefulWidget {
  const DNAuswahlPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DNAuswahlPage> {
  final storage = const FlutterSecureStorage();
  bool _offlineModus = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String? cookie = await storage.read(key: 'cookie');
    if (cookie != null && await ApiHandler.checkConnectivity() == true) {
      await ApiHandler.fetchDienstnehmerData(cookie);
      setState(() {});
      _isLoading = false;
    } else {
      _offlineModus = true;
      print("Offline mode enabled for Dienstnehmer Page");

      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check the orientation of the device
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator when data is loading
          : SingleChildScrollView(
              // Make the entire body scrollable
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Main content of the page
                children: [
                  const SizedBox(height: 40),
                  if (_offlineModus)
                    const Text("Offline Mode",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Image.asset(
                    'lib/images/LHR.png',
                    width: isLandscape
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width * 0.8,
                    height: isLandscape ? 320 : 200,
                    fit: BoxFit.contain, // Changed to BoxFit.contain
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          'DIENSTNEHMERAUSWAHL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        DynamicButtonsWidget(), // Adjust according to how DynamicButtonsWidget is implemented
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
