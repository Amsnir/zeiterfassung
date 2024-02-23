// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zeitspeicher.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZeitspeicherAdapter extends TypeAdapter<Zeitspeicher> {
  @override
  final int typeId = 7;

  @override
  Zeitspeicher read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zeitspeicher(
      nummer: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Zeitspeicher obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nummer)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZeitspeicherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
