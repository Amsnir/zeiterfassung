import 'package:flutter/material.dart';
import 'package:zeiterfassung_v1/dynamicbuttonswidget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmerstammtest.dart';
// Ensure you import your ApiHandler here
import 'package:zeiterfassung_v1/api/apiHandler.dart';

class DNAuswahlPage extends StatefulWidget {
  const DNAuswahlPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DNAuswahlPage> {
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String? cookie = await storage.read(key: 'cookie');
    if (cookie != null && ApiHandler.checkConnectivity()==true) {
      await ApiHandler.fetchDienstnehmerData(cookie);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 75),
          Image.asset('lib/images/LHR.png'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    'DIENSTNEHMERAUSWAHL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  Flexible(
                    // Wrap the DynamicButtonsWidget in a Flexible widget
                    child: SingleChildScrollView(
                      // Make it scrollable
                      child: DynamicButtonsWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
