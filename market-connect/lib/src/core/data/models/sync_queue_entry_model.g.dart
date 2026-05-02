// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncQueueEntryModelAdapter extends TypeAdapter<SyncQueueEntryModel> {
  @override
  final typeId = 8;

  @override
  SyncQueueEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncQueueEntryModel(
      id: fields[0] as String,
      operation: fields[1] as String,
      entityType: fields[2] as String,
      entityId: fields[3] as String?,
      payload: (fields[4] as Map).cast<String, dynamic>(),
      retryCount: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      lastError: fields[6] as String?,
      createdAt: fields[7] as DateTime,
      lastAttemptAt: fields[8] as DateTime?,
      status: fields[9] == null ? 'pending' : fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SyncQueueEntryModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.operation)
      ..writeByte(2)
      ..write(obj.entityType)
      ..writeByte(3)
      ..write(obj.entityId)
      ..writeByte(4)
      ..write(obj.payload)
      ..writeByte(5)
      ..write(obj.retryCount)
      ..writeByte(6)
      ..write(obj.lastError)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastAttemptAt)
      ..writeByte(9)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncQueueEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
