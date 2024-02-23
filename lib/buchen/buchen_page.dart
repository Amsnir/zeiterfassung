import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  // Assuming Zeitspeicher objects are being used, replacing List<String> with List<Zeitspeicher>
  List<Zeitspeicher> bookingOptions = []; // Holds Zeitspeicher objects
  Zeitspeicher? _selectedBookingOption; // Holds the selected name as a String

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    // Fetch zeitdaten and store it in Hive
    _fetchAndStoreZeitdaten();
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
    if (_selectedBookingOption != null && await ApiHandler.checkConnectivity()==true) {
      var bookingFuture = ApiHandler.buchen(
        dienstnehmer: widget.dienstnehmer,
        buchungsdatum:
            DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
        zeitdatenId: _selectedBookingOption!.nummer,
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
    } else if(await ApiHandler.checkConnectivity()==false){

       saveOfflineBuchung(
      faKz: widget.dienstnehmer.faKz,
      faNr: widget.dienstnehmer.faNr,
      dnNr: widget.dienstnehmer.dnNr,
      nummer: _selectedBookingOption!.nummer,
      timestamp: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()),
    );
        print("Buchen nicht erfolgreich");
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
  Box<Buchungen> offlinebuchungBox = await HiveFactory.openBox<Buchungen>('offlinebuchung');
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
            _showofflineMessage  = true;
          });
      Future.delayed(const Duration(seconds: 5), () {
            setState(() {
              _showSuccessMessage = false;
            });
          });

  await HiveFactory.closeBox(offlinebuchungBox);
}

//------------------------ Frontend ----------------------------

 @override
Widget build(BuildContext context) {
 return Scaffold(
    body: _isLoading 
      ? Center(child: CircularProgressIndicator()) // Show loading indicator when data is loading
      : Column(
         mainAxisAlignment: MainAxisAlignment.center, // Main content of the page
          children: [
          const SizedBox(height: 10),
           if (_offlineModus)
              const Text("Offline Mode",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold)),

             const SizedBox(height: 75),
            Image.asset('lib/images/LHR.png'), 
            Text(
              _timeString,
              style: const TextStyle(
                  fontSize: 50.0,
                  color: Color(0xFF443B5A),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),
            DropdownButtonHideUnderline(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color:
                      Colors.grey[200], // Adjust the color to match the button
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: DropdownButton<Zeitspeicher>(
                  value: _selectedBookingOption,
                  icon: const Icon(Icons.arrow_downward, color: Colors.grey),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (Zeitspeicher? newValue) {
                    setState(() {
                      _selectedBookingOption = newValue;
                    });
                  },
                  items: bookingOptions.map<DropdownMenuItem<Zeitspeicher>>(
                      (Zeitspeicher value) {
                    return DropdownMenuItem<Zeitspeicher>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 100),

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
            if(_showofflineMessage)
              const Text("Buchung lokal gespeichert. Keine Internetverbindung",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold)),

          ],

        ),
 );
  }
}
