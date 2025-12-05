// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CounterpartyAdapter extends TypeAdapter<Counterparty> {
  @override
  final int typeId = 3;

  @override
  Counterparty read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Counterparty(
      id: fields[0] as String,
      name: fields[1] as String,
      phone: fields[2] as String?,
      email: fields[3] as String?,
      avatarPath: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Counterparty obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.avatarPath)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterpartyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
