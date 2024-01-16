import 'dart:ffi';
import 'package:hive_flutter/hive_flutter.dart';

part 'dienstnehmer.g.dart';

@HiveType(typeId: 0)
class Dienstnehmer extends HiveObject {
  @HiveField(0)
  late int DN_ID;

  @HiveField(1)
  late Char DN_FA_KZ;

  @HiveField(2)
  late int DN_FA_NR;

  @HiveField(3)
  late int DN_NR;

  @HiveField(4)
  late Char DN_NAME;

  @HiveField(5)
  late Char DN_VORNAME;

  @HiveField(6)
  late int DN_STATUS;
}