import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/dashboard.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmerstammtest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

class DynamicButtonsWidget extends StatefulWidget {
  @override
  _DynamicButtonsWidgetState createState() => _DynamicButtonsWidgetState();
}

class _DynamicButtonsWidgetState extends State<DynamicButtonsWidget> {
  late List<Dienstnehmerstamm> dienstnehmerList = [];

  @override
  void initState() {
    super.initState();
    loadDienstnehmerData();
  }

  void loadDienstnehmerData() async {
    final box =
        await HiveFactory.listBox<Dienstnehmerstamm>('dienstnehmerstammtest');
    setState(() {
      dienstnehmerList = box;
    });
  }

  Widget _buildButtons() {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: dienstnehmerList.length,
        itemBuilder: (context, index) {
          final dienstnehmer = dienstnehmerList[index];
          String buttonLabel = "${dienstnehmer.nachname} ${dienstnehmer.name}";
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => BuchenFenster(
                            dienstnehmer: dienstnehmer,
                          )));
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
    return dienstnehmerList.isEmpty
        ? CircularProgressIndicator()
        : _buildButtons();
  }
}
