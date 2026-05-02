// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repayment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepaymentModelAdapter extends TypeAdapter<RepaymentModel> {
  @override
  final typeId = 7;

  @override
  RepaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepaymentModel(
      id: (fields[0] as num).toInt(),
      farmerId: (fields[1] as num).toInt(),
      farmerName: fields[2] as String,
      amount: (fields[3] as num).toDouble(),
      paymentMethod: fields[4] as String,
      reference: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      commodityName: fields[7] as String?,
      commodityRate: (fields[8] as num?)?.toDouble(),
      commodityKg: (fields[9] as num?)?.toDouble(),
      isSynced: fields[10] == null ? false : fields[10] as bool,
      debtAllocations: (fields[11] as List?)
          ?.map((e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, RepaymentModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.farmerId)
      ..writeByte(2)
      ..write(obj.farmerName)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.paymentMethod)
      ..writeByte(5)
      ..write(obj.reference)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.commodityName)
      ..writeByte(8)
      ..write(obj.commodityRate)
      ..writeByte(9)
      ..write(obj.commodityKg)
      ..writeByte(10)
      ..write(obj.isSynced)
      ..writeByte(11)
      ..write(obj.debtAllocations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
