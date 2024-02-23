import 'package:hive_flutter/hive_flutter.dart';

part 'offlinebuchung.g.dart';

@HiveType(typeId: 1)
class Buchungen extends HiveObject {
    @HiveField(0)
  final String faKz;

  @HiveField(1)
  final int faNr;

  @HiveField(2)
  final int dnNr;

  @HiveField(3)
  final int nummer;

  @HiveField(4)
  final String timestamp;

  Buchungen(
      {required this.faKz,
      required this.faNr,
      required this.dnNr,
      required this.nummer,
      required this.timestamp});
}
