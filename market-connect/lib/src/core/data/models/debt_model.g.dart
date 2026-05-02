// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtModelAdapter extends TypeAdapter<DebtModel> {
  @override
  final typeId = 6;

  @override
  DebtModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtModel(
      id: (fields[0] as num).toInt(),
      transactionId: (fields[1] as num?)?.toInt(),
      farmerId: (fields[2] as num).toInt(),
      farmerName: fields[3] as String,
      principal: (fields[4] as num).toDouble(),
      interestRate: (fields[5] as num).toDouble(),
      totalDue: (fields[6] as num).toDouble(),
      amountRepaid: (fields[7] as num).toDouble(),
      balance: (fields[8] as num).toDouble(),
      status: fields[9] as String,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime?,
      reference: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DebtModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.transactionId)
      ..writeByte(2)
      ..write(obj.farmerId)
      ..writeByte(3)
      ..write(obj.farmerName)
      ..writeByte(4)
      ..write(obj.principal)
      ..writeByte(5)
      ..write(obj.interestRate)
      ..writeByte(6)
      ..write(obj.totalDue)
      ..writeByte(7)
      ..write(obj.amountRepaid)
      ..writeByte(8)
      ..write(obj.balance)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.reference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
