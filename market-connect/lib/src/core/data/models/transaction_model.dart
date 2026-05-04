import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';
import '../../../extensions/json_extension.dart';
import 'transaction_item_model.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 5)
class TransactionModel extends Equatable {
  @HiveField(0)
  final int? id;
  
  @HiveField(1)
  final String? reference;
  
  @HiveField(2)
  final int farmerId;
  
  @HiveField(3)
  final String farmerName;
  
  @HiveField(4)
  final String paymentMethod;
  
  @HiveField(5)
  final double totalAmount;
  
  @HiveField(6)
  final String status;
  
  @HiveField(7)
  final List<TransactionItemModel> items;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final bool isSynced;
  
  @HiveField(10)
  final double? interestAmount;
  
  @HiveField(11)
  final double? subtotal;

  const TransactionModel({
    this.id,
    this.reference,
    required this.farmerId,
    required this.farmerName,
    required this.paymentMethod,
    required this.totalAmount,
    this.status = 'completed',
    required this.items,
    required this.createdAt,
    this.isSynced = false,
    this.interestAmount,
    this.subtotal,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json.jsonIntOrNull('id'),
      reference: json['reference'] as String?,
      farmerId: json.jsonInt('farmer_id'),
      farmerName: json['farmer']?['name'] as String? ?? '',
      paymentMethod: json['payment_method'] as String,
      totalAmount: json.jsonDouble('total_amount'),
      status: json['status'] as String? ?? 'completed',
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TransactionItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      isSynced: json['is_synced'] as bool? ?? true,
      interestAmount: json.jsonDoubleOrNull('interest_amount'),
      subtotal: json.jsonDoubleOrNull('subtotal'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'farmer_id': farmerId,
      'farmer_name': farmerName,
      'payment_method': paymentMethod,
      'total_amount': totalAmount,
      'status': status,
      'items': items.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'is_synced': isSynced,
      'interest_amount': interestAmount,
      'subtotal': subtotal,
    };
  }

  @override
  List<Object?> get props => [
    id, reference, farmerId, farmerName, paymentMethod, 
    totalAmount, status, items, createdAt, isSynced, interestAmount, subtotal
  ];
}
