import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';

part 'sync_queue_entry_model.g.dart';

@HiveType(typeId: 8)
class SyncQueueEntryModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String operation;
  
  @HiveField(2)
  final String entityType;
  
  @HiveField(3)
  final String? entityId;
  
  @HiveField(4)
  final Map<String, dynamic> payload;
  
  @HiveField(5)
  final int retryCount;
  
  @HiveField(6)
  final String? lastError;
  
  @HiveField(7)
  final DateTime createdAt;
  
  @HiveField(8)
  final DateTime? lastAttemptAt;
  
  @HiveField(9)
  final String status;

  const SyncQueueEntryModel({
    required this.id,
    required this.operation,
    required this.entityType,
    this.entityId,
    required this.payload,
    this.retryCount = 0,
    this.lastError,
    required this.createdAt,
    this.lastAttemptAt,
    this.status = 'pending',
  });

  factory SyncQueueEntryModel.create({
    required String operation,
    required String entityType,
    String? entityId,
    required Map<String, dynamic> payload,
  }) {
    return SyncQueueEntryModel(
      id: '${DateTime.now().millisecondsSinceEpoch}_$entityType',
      operation: operation,
      entityType: entityType,
      entityId: entityId,
      payload: payload,
      createdAt: DateTime.now(),
    );
  }

  SyncQueueEntryModel copyWith({
    String? id,
    String? operation,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? payload,
    int? retryCount,
    String? lastError,
    DateTime? createdAt,
    DateTime? lastAttemptAt,
    String? status,
  }) {
    return SyncQueueEntryModel(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id, operation, entityType, entityId, payload,
    retryCount, lastError, createdAt, lastAttemptAt, status,
  ];
}
