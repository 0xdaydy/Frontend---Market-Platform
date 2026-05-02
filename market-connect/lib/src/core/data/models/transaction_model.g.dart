// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final typeId = 5;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: (fields[0] as num?)?.toInt(),
      reference: fields[1] as String?,
      farmerId: (fields[2] as num).toInt(),
      farmerName: fields[3] as String,
      paymentMethod: fields[4] as String,
      totalAmount: (fields[5] as num).toDouble(),
      status: fields[6] == null ? 'completed' : fields[6] as String,
      items: (fields[7] as List).cast<TransactionItemModel>(),
      createdAt: fields[8] as DateTime,
      isSynced: fields[9] == null ? false : fields[9] as bool,
      interestAmount: (fields[10] as num?)?.toDouble(),
      subtotal: (fields[11] as num?)?.toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reference)
      ..writeByte(2)
      ..write(obj.farmerId)
      ..writeByte(3)
      ..write(obj.farmerName)
      ..writeByte(4)
      ..write(obj.paymentMethod)
      ..writeByte(5)
      ..write(obj.totalAmount)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.items)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.isSynced)
      ..writeByte(10)
      ..write(obj.interestAmount)
      ..writeByte(11)
      ..write(obj.subtotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
