import 'package:hive_flutter/hive_flutter.dart';

part 'abwesenheiten.g.dart';

@HiveType(typeId: 2)
class Abwesenheiten extends HiveObject {
  @HiveField(0)
  late int ABW_NR;

  @HiveField(1)
  late int ABW_BEZEICHNUNG;
}