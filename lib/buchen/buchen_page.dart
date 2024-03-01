import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeiterfassung_v1/DNAuswahl.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmerstammtest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/zeitspeicher.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/offlinebuchung.dart';

import 'package:hive_flutter/hive_flutter.dart'; // Make sure to import Hive

class BuchenPage extends StatefulWidget {
  final Dienstnehmer dienstnehmer;
  final Dienstnehmerstamm dienstnehmerstamm;

  BuchenPage(
      {Key? key, required this.dienstnehmer, required this.dienstnehmerstamm})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BuchenPageState createState() => _BuchenPageState();
}

class _BuchenPageState extends State<BuchenPage> {
  late String _timeString;
  bool _showSuccessMessage = false;
  bool _showofflineMessage = false;
  bool _offlineModus = false;
  bool _isLoading = true;
  bool zeitende = false;
  bool _isBookingInProgress = false;

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
        // If the checkbox is not checked, use the selected Buchen option's number
        nummerToSend = _selectedBookingOption?.nummer ??
            -1; // Use a default or handle error
      }

      // Proceed with booking using nummerToSend
      var bookingFuture = ApiHandler.buchen(
        dienstnehmer: widget.dienstnehmer,
        buchungsdatum:
            DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
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
        nummer: zeitende ? -2 : _selectedBookingOption?.nummer ?? -1,
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
        _showofflineMessage = false;
      });
    });

    await HiveFactory.closeBox(offlinebuchungBox);
  }

//------------------------ UI DESIGN ----------------------------

  @override
  Widget build(BuildContext context) {
    // Determine if the device is in landscape mode
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24.0),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const DNAuswahlPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_offlineModus)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Offline Mode",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ),
                        Image.asset(
                          'lib/images/LHR.png',
                          width: isLandscape
                              ? MediaQuery.of(context).size.width * 0.5
                              : MediaQuery.of(context).size.width * 0.8,
                          height: isLandscape ? 320 : 200,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: Text(
                            "${widget.dienstnehmerstamm.nachname} ${widget.dienstnehmerstamm.name}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            _timeString,
                            style: const TextStyle(
                                fontSize: 50.0,
                                color: Color(0xFF443B5A),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                              'Zeitende',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (!zeitende)
                          DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
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
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 75),
                          child: ElevatedButton(
                            onPressed: _isBookingInProgress
                                ? null
                                : () async {
                                    setState(() {
                                      _isBookingInProgress = true;
                                    });
                                    await _attemptBooking();
                                    setState(() {
                                      _isBookingInProgress = false;
                                    });
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: _isBookingInProgress
                                    ? Colors.grey
                                    : const Color.fromRGBO(28, 53, 80, 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                alignment: Alignment.center,
                                child: _isBookingInProgress
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        "B U C H E N",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        if (_showSuccessMessage)
                          const Text("Buchung erfolgreich",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        if (_showofflineMessage)
                          const Text(
                              "Buchung lokal gespeichert. Keine Verbindung zum Server",
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
