// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abwesenheiten.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbwesenheitenAdapter extends TypeAdapter<Abwesenheiten> {
  @override
  final int typeId = 2;

  @override
  Abwesenheiten read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Abwesenheiten()
      ..ABW_NR = fields[0] as int
      ..ABW_BEZEICHNUNG = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, Abwesenheiten obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ABW_NR)
      ..writeByte(1)
      ..write(obj.ABW_BEZEICHNUNG);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbwesenheitenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
