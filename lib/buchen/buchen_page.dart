import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // Ensure this is added for date formatting

class BuchenPage extends StatefulWidget {
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
    return DateFormat('HH:mm:ss')
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
            ElevatedButton(
              onPressed: () {
                // Button action here
              },
              child: Text('Press Me'),
            ),
          ],
        ),
      ),
    );
  }
}
