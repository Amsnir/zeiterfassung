import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'zeitspeicher.g.dart';

@HiveType(typeId: 7)
class Zeitspeicher {
  @HiveField(0)
  final int nummer;

  @HiveField(1)
  final String name;

  Zeitspeicher({required this.nummer, required this.name});
}
