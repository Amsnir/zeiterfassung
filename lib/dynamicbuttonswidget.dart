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
    final box = Hive.box<Dienstnehmerstamm>('dienstnehmerstammtest');
    setState(() {
      dienstnehmerList = box.values.toList();
    });
  }

  Widget _buildButtons() {
    return ListView.builder(
      itemCount: dienstnehmerList.length,
      itemBuilder: (context, index) {
        final dienstnehmer = dienstnehmerList[index];
        String buttonLabel = "${dienstnehmer.nachname} ${dienstnehmer.name}";
        return ElevatedButton(
          onPressed: () {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BuchenFenster(dienstnehmer: dienstnehmer,)));
          },
          child: Text(buttonLabel),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return dienstnehmerList.isEmpty
        ? CircularProgressIndicator()
        : _buildButtons();
  }
}