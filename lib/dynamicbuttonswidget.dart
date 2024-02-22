import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/dashboard.dart';
import 'package:zeiterfassung_v1/buchen/buchen_page.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmerstammtest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

class DynamicButtonsWidget extends StatefulWidget {
  @override
  _DynamicButtonsWidgetState createState() => _DynamicButtonsWidgetState();
}

class _DynamicButtonsWidgetState extends State<DynamicButtonsWidget> {
  //Creating 2 Lists
  late List<Dienstnehmerstamm> dienstnehmerstammList = [];
  late List<Dienstnehmer> dienstnehmerList = [];

  @override
  void initState() {
    super.initState();
    loadDienstnehmerData();
  }

  void loadDienstnehmerData() async {
    final dienstnehmerstammdaten =
        await HiveFactory.listBox<Dienstnehmerstamm>('dienstnehmerstammtest');
    final dienstnehmerdaten =
        await HiveFactory.listBox<Dienstnehmer>('dienstnehmertest');

    setState(() {
      // the lists seperate dienstnehmerstamm (name, nachname) and dienstnehmer(faNr, faKz, dnNr)
      dienstnehmerstammList = dienstnehmerstammdaten;
      dienstnehmerList = dienstnehmerdaten;
    });
  }

  Widget _buildButtons() {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: dienstnehmerstammList.length,
        itemBuilder: (context, index) {
          final dienstnehmerstamm = dienstnehmerstammList[index];
          String buttonLabel =
              "${dienstnehmerstamm.nachname} ${dienstnehmerstamm.name}";
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Assuming dienstnehmerList[index] contains the corresponding Dienstnehmer data
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BuchenPage(
                          dienstnehmer:
                              dienstnehmerList[index]), // Adjust this line
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

  @override
  Widget build(BuildContext context) {
    return dienstnehmerstammList.isEmpty
        ? CircularProgressIndicator()
        : _buildButtons();
  }
}
