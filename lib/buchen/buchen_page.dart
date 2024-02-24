import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeiterfassung_v1/DNAuswahl.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/zeitspeicher.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/offlinebuchung.dart';

import 'package:hive_flutter/hive_flutter.dart'; // Make sure to import Hive

class BuchenPage extends StatefulWidget {
  final Dienstnehmer dienstnehmer;

  BuchenPage({Key? key, required this.dienstnehmer}) : super(key: key);

  @override
  _BuchenPageState createState() => _BuchenPageState();
}

class _BuchenPageState extends State<BuchenPage> {
  late String _timeString;
  bool _showSuccessMessage = false;
  bool _showofflineMessage = false;
  bool _offlineModus = false;
  bool _isLoading = true;
  bool zeitende = false;

  Timer? _timer;
  List<Zeitspeicher> bookingOptions = []; // Holds Zeitspeicher objects
  Zeitspeicher? _selectedBookingOption; // Holds the selected name as a String

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    _fetchAndStoreZeitdaten();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

//-------------------- Zeitspeicher wird geladen ----------------------------

  void _fetchAndStoreZeitdaten() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    if (await ApiHandler.checkConnectivity()) {
      await ApiHandler.fetchZeitdaten(widget.dienstnehmer);
      // Assuming fetchZeitdaten stores the fetched data in Hive
    } else {
      _offlineModus = true;
      print("Offline mode enabled for Buchen Page");
    }

    _loadDataFromHive(); // Load the stored data into the widget state

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  void _loadDataFromHive() async {
    var box = await HiveFactory.openBox<Zeitspeicher>('zeitspeicher');
    List<Zeitspeicher> zeitdaten = box.values.toList();

    setState(() {
      bookingOptions = zeitdaten;
      if (bookingOptions.isNotEmpty) {
        _selectedBookingOption = bookingOptions.first;
      } else {
        _selectedBookingOption = null;
      }
    });

    await box.close();
    print("Loaded ${bookingOptions.length} booking options from Hive.");
  }

//------------------Aktuelle Zeit des Handys holen ----------------------------

  void _getTime() {
    final String formattedDateTime = _formatDateTime(DateTime.now());
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

//---------------------Buchen versuchen oder in offline Einfügen -------------------------

  Future<void> _attemptBooking() async {
  // Check connectivity first
  if (await ApiHandler.checkConnectivity() == true) {
    int nummerToSend;
    if (zeitende) {
      // If the checkbox is checked, set the special value
      nummerToSend = -2;
    } else {
      // If the checkbox is not checked, use the selected booking option's number
      // Make sure to handle the case where _selectedBookingOption might be null
      nummerToSend = _selectedBookingOption?.nummer ?? -1; // Use a default or handle error
    }

    // Proceed with booking using nummerToSend
    var bookingFuture = ApiHandler.buchen(
      dienstnehmer: widget.dienstnehmer,
      buchungsdatum: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
      zeitdatenId: nummerToSend,
    );

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
  } else if (await ApiHandler.checkConnectivity() == false) {
    // If offline, handle offline saving similarly using nummerToSend
    saveOfflineBuchung(
      faKz: widget.dienstnehmer.faKz,
      faNr: widget.dienstnehmer.faNr,
      dnNr: widget.dienstnehmer.dnNr,
      nummer: zeitende ? -2 : _selectedBookingOption?.nummer ?? -1, // Use special value or selected option
      timestamp: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
    );
    print("Buchen nicht erfolgreich - offline mode");
  }
}
//----------------- Saving Buchung into offline Database ------------------------

  Future<void> saveOfflineBuchung({
    required String faKz,
    required int faNr,
    required int dnNr,
    required int nummer,
    required String timestamp,
  }) async {
    Box<Buchungen> offlinebuchungBox =
        await HiveFactory.openBox<Buchungen>('offlinebuchung');
    final buchung = Buchungen(
      faKz: faKz,
      faNr: faNr,
      dnNr: dnNr,
      nummer: nummer,
      timestamp: timestamp,
    );

    await offlinebuchungBox.add(buchung);
    print("Items in zeitspeicherBox: ${offlinebuchungBox.length}");

    setState(() {
      _showofflineMessage = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _showSuccessMessage = false;
      });
    });

    await HiveFactory.closeBox(offlinebuchungBox);
  }

//------------------------ UI DESIGN ----------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Use SafeArea to avoid status bar overlap
        child: SingleChildScrollView(
          // Wrap your column in a SingleChildScrollView
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        size: 24.0), // Customize back arrow icon as needed
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              DNAuswahlPage(), // Adjust this line
                        ),
                      );
                    },
                  ),
                ],
              ),
              _isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator()) // Show loading indicator when data is loading
                  : Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Main content of the page
                      children: [
                        const SizedBox(height: 1),
                        if (_offlineModus)
                          const Text("Offline Mode",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),

                        const SizedBox(height: 25),
                        Image.asset('lib/images/LHR.png'),
                        Text(
                          _timeString,
                          style: const TextStyle(
                              fontSize: 50.0,
                              color: Color(0xFF443B5A),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 25), // Adjust spacing as needed
// Wrap your Checkbox and Text in a Row for horizontal layout
                        Row(
                          mainAxisSize:
                              MainAxisSize.min, // Use min to fit content size
                          children: [
                            Checkbox(
                              value: zeitende,
                              onChanged: (bool? value) {
                                setState(() {
                                  zeitende = value!;
                                });
                              },
                            ),
                            const Text(
                              'Buchungsende',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30.0),
                        if (zeitende == false)
                          DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey[
                                    200], // Adjust the color to match the button
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                              ),
                              child: DropdownButton<Zeitspeicher>(
                                value: _selectedBookingOption,
                                icon: const Icon(Icons.arrow_downward,
                                    color: Colors.grey),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (Zeitspeicher? newValue) {
                                  setState(() {
                                    _selectedBookingOption = newValue;
                                  });
                                },
                                items: bookingOptions
                                    .map<DropdownMenuItem<Zeitspeicher>>(
                                        (Zeitspeicher value) {
                                  return DropdownMenuItem<Zeitspeicher>(
                                    value: value,
                                    child: Text(value.name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        const SizedBox(height: 50),

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
                                    fontSize: 16),
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
                                  fontWeight: FontWeight.bold)),
                        if (_showofflineMessage)
                          const Text(
                              "Buchung lokal gespeichert. Keine Internetverbindung",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold)),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
