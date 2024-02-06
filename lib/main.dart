import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/DNAuswahl.dart';
import 'package:zeiterfassung_v1/api/synchdb.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

void main() async {
  await HiveFactory.initHive();
  await HiveFactory.registerAdapter();

  synchData();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: DNAuswahlPage());
  }
}
