import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/dashboard.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_Klassen/dienstnehmer.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

class DynamicButtonsWidget extends StatefulWidget {
  @override
  _DynamicButtonsWidgetState createState() => _DynamicButtonsWidgetState();
}

class _DynamicButtonsWidgetState extends State<DynamicButtonsWidget> {
  late List<Dienstnehmer>? dienstnehmerList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HiveFactory.listBox<Dienstnehmer>('dienstnehmer'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          dienstnehmerList = snapshot.data;
          return _buildButtons();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dienstnehmerList!.length,
        (index) {
          Dienstnehmer? fromDB = dienstnehmerList!.elementAt(index);
          String buttonLabel = fromDB.DN_NAME;

          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BuchenFenster(
                        dienstnehmer: fromDB,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.grey,
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          );
        },
      ),
    );
  }
}
