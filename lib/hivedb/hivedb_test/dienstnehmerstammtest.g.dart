// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dienstnehmerstammtest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DienstnehmerstammAdapter extends TypeAdapter<Dienstnehmerstamm> {
  @override
  final int typeId = 6;

  @override
  Dienstnehmerstamm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dienstnehmerstamm(
      name: fields[0] as String,
      nachname: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Dienstnehmerstamm obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.nachname);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DienstnehmerstammAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
