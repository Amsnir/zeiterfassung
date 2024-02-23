// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offlinebuchung.dart';

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
      faKz: fields[0] as String,
      faNr: fields[1] as int,
      dnNr: fields[2] as int,
      nummer: fields[3] as int,
      timestamp: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Buchungen obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.faKz)
      ..writeByte(1)
      ..write(obj.faNr)
      ..writeByte(2)
      ..write(obj.dnNr)
      ..writeByte(3)
      ..write(obj.nummer)
      ..writeByte(4)
      ..write(obj.timestamp);
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
