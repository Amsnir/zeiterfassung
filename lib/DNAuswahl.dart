import 'package:flutter/material.dart';
import 'package:zeiterfassung_v1/dashboard.dart';

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
  String dienstnehmer = "";

  String getDienstnehmer() {
    return dienstnehmer;
  }

  void navigateToBuchenFenster() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuchenFenster(dienstnehmer: dienstnehmer),
      ),
    );
  }

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
                  SizedBox(height: 20.0),
                  const Text(
                    'DIENSTNEHMER AUSWAHL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      dienstnehmer = "Lukei Spugei";
                      navigateToBuchenFenster();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Colors.grey,
                    ),
                    child: const Text(
                      'Lukei Spugei',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      dienstnehmer = "Vitus Emberger";
                      navigateToBuchenFenster();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Colors.grey,
                    ),
                    child: const Text(
                      'Vitus Emberger',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      dienstnehmer = "Florian Kössler";
                      navigateToBuchenFenster();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Colors.grey,
                    ),
                    child: const Text(
                      "Florian Kössler",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
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
