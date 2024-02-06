import 'package:flutter/material.dart';
import 'package:zeiterfassung_v1/dynamicbuttonswidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DNAuswahlPage(),
    );
  }
}

class DNAuswahlPage extends StatefulWidget {
  const DNAuswahlPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DNAuswahlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /*Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Image.asset(
              'assets/LHR_Logo_orange-blau_RGB_transparent_Latzer.png',
              width: 300.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),*/
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    'Dienstnehmerauswahl',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  DynamicButtonsWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
