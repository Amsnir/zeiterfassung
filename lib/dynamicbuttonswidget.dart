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
  late Box<Dienstnehmer>? dienstnehmerBox;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HiveFactory.openBox<Dienstnehmer>('dienstnehmer'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          dienstnehmerBox = snapshot.data;
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
        dienstnehmerBox!.length,
        (index) {
          Dienstnehmer? fromDB = dienstnehmerBox!.getAt(index);
          String buttonLabel = fromDB?.DN_NAME ?? "Unbekannter Dienstnehmer";

          if (index + 1 == dienstnehmerBox!.length) {
            dienstnehmerBox!.close();
          }

          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (fromDB != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuchenFenster(
                          dienstnehmer: fromDB as Dienstnehmer,
                        ),
                      ),
                    );
                  }
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
