import 'package:hive_flutter/hive_flutter.dart';

part 'synch.g.dart';

@HiveType(typeId: 4)
class Synch extends HiveObject {
  @HiveField(0)
  late int SYNCH_BU_ID;

  @HiveField(1)
  late DateTime SYNCH_ERSTELLDATUM;

  @HiveField(2)
  late DateTime SYNCH_BEARBEITET;

  @HiveField(3)
  late int SYNCH_FEHLER_ID;
}