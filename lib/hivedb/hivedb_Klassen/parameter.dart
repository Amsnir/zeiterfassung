import 'dart:ffi';
import 'package:hive_flutter/hive_flutter.dart';

part 'parameter.g.dart';

@HiveType(typeId: 3)
class Parameter extends HiveObject {
  @HiveField(0)
  late String PAR_API_URL;

  @HiveField(1)
  late String PAR_LOGONNAME;

  @HiveField(2)
  late String PAR_PASSWORT;

  @HiveField(3)
  late String PAR_MAIL;

  @HiveField(4)
  late String PAR_SECRET;

  @HiveField(5)
  late int PAR_TAGE_BEARB;
}
