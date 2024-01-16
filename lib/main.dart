import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/hivedb_Klassen/abwesenheiten.dart';
import 'package:zeiterfassung_v1/hivedb_Klassen/buchungen.dart';
import 'package:zeiterfassung_v1/hivedb_Klassen/dienstnehmer.dart';
import 'package:zeiterfassung_v1/hivedb_Klassen/parameter.dart';
import 'package:zeiterfassung_v1/hivedb_Klassen/synch.dart';
import 'package:zeiterfassung_v1/dashboard.dart';

void main() async{
  await Hive.initFlutter();
  
  await Hive.openBox<Dienstnehmer>('dienstnehmer');
  await Hive.openBox<Buchungen>('buchungen');
  await Hive.openBox<Abwesenheiten>('abwesenheiten');
  await Hive.openBox<Parameter>('parameter');
  await Hive.openBox<Synch>('synch');

  Hive.registerAdapter(DienstnehmerAdapter());
  Hive.registerAdapter(BuchungenAdapter());
  Hive.registerAdapter(AbwesenheitenAdapter());
  Hive.registerAdapter(ParameterAdapter());
  Hive.registerAdapter(SynchAdapter());


  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
