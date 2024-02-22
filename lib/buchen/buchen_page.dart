import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // Ensure this is added for date formatting
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';

class BuchenPage extends StatefulWidget {
  final Dienstnehmer dienstnehmer; // Add this line

  BuchenPage({Key? key, required this.dienstnehmer})
      : super(key: key); // Modify this line

  @override
  _BuchenPageState createState() => _BuchenPageState();
}

class _BuchenPageState extends State<BuchenPage> {
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final String formattedDateTime = _formatDateTime(DateTime.now());
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm')
        .format(dateTime); // Using intl package for formatting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _timeString,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Format the current date-time
                String buchungsdatum =
                    DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
                // Call the buchen function with the formatted date-time
                ApiHandler.buchen(
                    dienstnehmer: widget.dienstnehmer,
                    buchungsdatum: buchungsdatum);
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 75),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(28, 53, 80, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "B U C H E N",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
