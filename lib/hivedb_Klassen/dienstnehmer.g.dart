// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dienstnehmer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DienstnehmerAdapter extends TypeAdapter<Dienstnehmer> {
  @override
  final int typeId = 0;

  @override
  Dienstnehmer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dienstnehmer()
      ..DN_ID = fields[0] as int
      ..DN_FA_KZ = fields[1] as Char
      ..DN_FA_NR = fields[2] as int
      ..DN_NR = fields[3] as int
      ..DN_NAME = fields[4] as Char
      ..DN_VORNAME = fields[5] as Char
      ..DN_STATUS = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, Dienstnehmer obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.DN_ID)
      ..writeByte(1)
      ..write(obj.DN_FA_KZ)
      ..writeByte(2)
      ..write(obj.DN_FA_NR)
      ..writeByte(3)
      ..write(obj.DN_NR)
      ..writeByte(4)
      ..write(obj.DN_NAME)
      ..writeByte(5)
      ..write(obj.DN_VORNAME)
      ..writeByte(6)
      ..write(obj.DN_STATUS);
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
