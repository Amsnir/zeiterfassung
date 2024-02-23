import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'dienstnehmertest.g.dart';

@HiveType(typeId: 5)
class Dienstnehmer {
  @HiveField(0)
  final String faKz;

  @HiveField(1)
  final int faNr;

  @HiveField(2)
  final int dnNr;

  Dienstnehmer({required this.faKz, required this.faNr, required this.dnNr});
}
