import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeiterfassung_v1/buchen.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_Klassen/dienstnehmer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BuchenFenster(
        dienstnehmer: Dienstnehmer(),
      ),
    );
  }
}

class BuchenFenster extends StatefulWidget {
  final Dienstnehmer dienstnehmer;

  BuchenFenster({Key? key, required this.dienstnehmer}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<BuchenFenster> {
  List<String> dropdownItems = ['Normale Buchung', 'Dienstgang', 'Homeoffice'];
  String selectedDropdownItem = 'Normale Buchung';
  bool isChecked = false;
  late Timer _timer;
  late String _formatted;

  int ABW_NR = 0;
  int ABW_BEZEICHNUNG = 0;
  int BU_ID = 0;
  //final DateTime BU_TIMESTAMP;
  int BU_DN_ID = 0;
  int BU_ABW_NR = 0;

  @override
  void initState() {
    super.initState();

    _formatted = DateFormat('HH:mm').format(DateTime.now());

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _formatted = DateFormat('HH:mm').format(DateTime.now());
      });
    });
  }

  void buchenWithDienstnehmer() {
    buchen(widget.dienstnehmer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Image.asset(
              'lib/images/LHR.png',
              width: 300.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          // Label above the clock
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              widget.dienstnehmer.DN_NAME.toString(),
              style: const TextStyle(fontSize: 20.0, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    _formatted,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 50.0,
                        color: Color(0xFF443B5A),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Buchungsende',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  if (isChecked == false)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey[300],
                        ),
                        child: DropdownButton<String>(
                          value: selectedDropdownItem,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDropdownItem = newValue!;
                            });
                          },
                          items: dropdownItems.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          dropdownColor: Colors.grey[300],
                        ),
                      ),
                    ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: buchenWithDienstnehmer,
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: const Color(0xFF443B5A),
                    ),
                    child: const Text(
                      'Buchen',
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
