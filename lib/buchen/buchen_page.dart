import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';

class BuchenPage extends StatefulWidget {
  final Dienstnehmer dienstnehmer;

  BuchenPage({Key? key, required this.dienstnehmer}) : super(key: key);

  @override
  _BuchenPageState createState() => _BuchenPageState();
}

class _BuchenPageState extends State<BuchenPage> {
  late String _timeString;
  bool _showSuccessMessage = false;
  List<String> bookingOptions = []; // Dropdown menu items
  String? _selectedBookingOption; // Selected item from the dropdown

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _fetchZeitdatenOptions();
  }

  void _fetchZeitdatenOptions() async {
    var options = await ApiHandler.fetchZeitdaten(widget.dienstnehmer);
    setState(() {
      bookingOptions = options; // Update your dropdown options list
      _selectedBookingOption =
          options.first; // Initialize with the first option
    });
  }

  void _getTime() {
    final String formattedDateTime = _formatDateTime(DateTime.now());
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  void _attemptBooking() {
    var bookingFuture = ApiHandler.buchen(
      dienstnehmer: widget.dienstnehmer,
      buchungsdatum: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
    );

    setState(() {});
//Buchung erfolgfreich wird nur für 5 Sekunden angezeigt
    bookingFuture.then((wasSuccessful) {
      if (wasSuccessful) {
        setState(() {
          _showSuccessMessage = true;
        });
        Future.delayed(const Duration(seconds: 5), () {
          setState(() {
            _showSuccessMessage = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            Image.asset('lib/images/LHR.png'),
            Text(
              _timeString,
              style: const TextStyle(
                  fontSize: 50.0,
                  color: Color(0xFF443B5A),
                  fontWeight: FontWeight.bold),
            ),
            DropdownButtonHideUnderline(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color:
                      Colors.grey[200], // Adjust the color to match the button
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: DropdownButton<String>(
                  value: _selectedBookingOption,
                  icon: const Icon(Icons.arrow_downward,
                      color: Colors.grey), // Adjust the icon color
                  elevation: 16,
                  style: const TextStyle(
                      color: Colors.black), // Adjust the text color
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBookingOption = newValue;
                    });
                  },
                  items: bookingOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _attemptBooking,
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
            const SizedBox(height: 20),
            if (_showSuccessMessage)
              const Text("Buchung erfolgreich",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  )),
          ],
        ),
      ),
    );
  }
}
