// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dienstnehmertest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DienstnehmerAdapter extends TypeAdapter<Dienstnehmer> {
  @override
  final int typeId = 5;

  @override
  Dienstnehmer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dienstnehmer(
      faKz: fields[0] as String,
      faNr: fields[1] as int,
      dnNr: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Dienstnehmer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.faKz)
      ..writeByte(1)
      ..write(obj.faNr)
      ..writeByte(2)
      ..write(obj.dnNr);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DienstnehmerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
