// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buchungen.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BuchungenAdapter extends TypeAdapter<Buchungen> {
  @override
  final int typeId = 1;

  @override
  Buchungen read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Buchungen(
      BU_ID: fields[0] as int,
      BU_DN_ID: fields[1] as int,
      BU_TIMESTAMP: fields[2] as DateTime,
      BU_ABW_NR: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Buchungen obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.BU_ID)
      ..writeByte(1)
      ..write(obj.BU_DN_ID)
      ..writeByte(2)
      ..write(obj.BU_TIMESTAMP)
      ..writeByte(3)
      ..write(obj.BU_ABW_NR);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuchungenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
