import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BuchenFenster(dienstnehmer: ''),
    );
  }
}

class BuchenFenster extends StatefulWidget {
  final String dienstnehmer;

  const BuchenFenster({Key? key, required this.dienstnehmer}) : super(key: key);

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
              'assets/LHR_Logo_orange-blau_RGB_transparent_Latzer.png',
              width: 300.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          // Label above the clock
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(12.0), // Adjust padding as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[300],
              ),
              child: Text(
                '${widget.dienstnehmer}',
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    _formatted,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 50.0, color: Color(0xFF443B5A), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
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
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
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
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Implement booking logic here
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Color(0xFF443B5A),
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
