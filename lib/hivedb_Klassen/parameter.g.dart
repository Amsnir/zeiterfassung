// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParameterAdapter extends TypeAdapter<Parameter> {
  @override
  final int typeId = 3;

  @override
  Parameter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Parameter()
      ..PAR_API_URL = fields[0] as Char
      ..PAR_LOGONNAME = fields[1] as Char
      ..PAR_PASSWORT = fields[2] as Char
      ..PAR_MAIL = fields[3] as Char
      ..PAR_SECRET = fields[4] as Char
      ..PAR_TAGE_BEARB = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, Parameter obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.PAR_API_URL)
      ..writeByte(1)
      ..write(obj.PAR_LOGONNAME)
      ..writeByte(2)
      ..write(obj.PAR_PASSWORT)
      ..writeByte(3)
      ..write(obj.PAR_MAIL)
      ..writeByte(4)
      ..write(obj.PAR_SECRET)
      ..writeByte(5)
      ..write(obj.PAR_TAGE_BEARB);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParameterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
