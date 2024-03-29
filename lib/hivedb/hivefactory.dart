import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmerstammtest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/zeitspeicher.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/offlinebuchung.dart';

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
    Hive.registerAdapter(DienstnehmerstammAdapter());
    Hive.registerAdapter(DienstnehmerAdapter());
    Hive.registerAdapter(ZeitspeicherAdapter());
    Hive.registerAdapter(BuchungenAdapter());
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
