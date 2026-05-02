// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FarmerModelAdapter extends TypeAdapter<FarmerModel> {
  @override
  final typeId = 1;

  @override
  FarmerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FarmerModel(
      id: (fields[0] as num).toInt(),
      cardId: fields[1] as String,
      name: fields[2] as String,
      phone: fields[3] as String?,
      village: fields[4] as String?,
      creditLimit: (fields[5] as num).toDouble(),
      creditBalanceFcfa: (fields[6] as num).toDouble(),
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FarmerModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.village)
      ..writeByte(5)
      ..write(obj.creditLimit)
      ..writeByte(6)
      ..write(obj.creditBalanceFcfa)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
