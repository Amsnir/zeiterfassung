import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_Klassen/abwesenheiten.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_Klassen/buchungen.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_Klassen/dienstnehmer.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_Klassen/parameter.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_Klassen/synch.dart';

class HiveFactory {
  static final HiveFactory _instance = HiveFactory._();

  factory HiveFactory() {
    return _instance;
  }

  HiveFactory._();

  static Future<void> initHive() async {
    await Hive.initFlutter('hivedb');
  }

  static Future<void> closeHive() async {
    await Hive.close();
  }

  static Future<void> registerAdapter() async {
    Hive.registerAdapter(DienstnehmerAdapter());
    Hive.registerAdapter(BuchungenAdapter());
    Hive.registerAdapter(AbwesenheitenAdapter());
    Hive.registerAdapter(ParameterAdapter());
    Hive.registerAdapter(SynchAdapter());
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  static Future<void> closeBox(Box b) async {
    await b.close();
  }

  static Future<List<T>> listBox<T>(String boxName) async {
    List<T> list = [];

    try {
      final box = await Hive.openBox<T>(boxName);
      list.addAll(box.values);
      await closeBox(box);
    } catch (e) {
      print('Error fetching values from box: $e');
    }

    return list;
  }
}
