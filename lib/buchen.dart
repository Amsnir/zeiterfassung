import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_Klassen/buchungen.dart';

import 'dart:developer';

import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

void buchen() async {
  final newBuchung = Buchungen(
      BU_ID: 3000, BU_DN_ID: 22, BU_TIMESTAMP: DateTime.now(), BU_ABW_NR: 1);
  final buchungBox = await HiveFactory.openBox<Buchungen>('buchungen');
  buchungBox.add(newBuchung);
  buchungBox.close();
}
