import 'package:hive_flutter/hive_flutter.dart';

part 'buchungen.g.dart';

@HiveType(typeId: 1)
class Buchungen extends HiveObject {
  @HiveField(0)
  late int BU_ID;

  @HiveField(1)
  late int BU_DN_ID;

  @HiveField(2)
  late DateTime BU_TIMESTAMP;

  @HiveField(3)
  late int BU_ABW_NR;
  
}