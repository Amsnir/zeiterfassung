import 'package:hive_flutter/hive_flutter.dart';

part 'dienstnehmerstammtest.g.dart';

@HiveType(typeId: 6)
class Dienstnehmerstamm{
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String nachname;


  Dienstnehmerstamm({required this.name, required this.nachname});
}


