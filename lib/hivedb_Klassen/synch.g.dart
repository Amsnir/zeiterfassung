// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SynchAdapter extends TypeAdapter<Synch> {
  @override
  final int typeId = 4;

  @override
  Synch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Synch()
      ..SYNCH_BU_ID = fields[0] as int
      ..SYNCH_ERSTELLDATUM = fields[1] as DateTime
      ..SYNCH_BEARBEITET = fields[2] as DateTime
      ..SYNCH_FEHLER_ID = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Synch obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.SYNCH_BU_ID)
      ..writeByte(1)
      ..write(obj.SYNCH_ERSTELLDATUM)
      ..writeByte(2)
      ..write(obj.SYNCH_BEARBEITET)
      ..writeByte(3)
      ..write(obj.SYNCH_FEHLER_ID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SynchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
