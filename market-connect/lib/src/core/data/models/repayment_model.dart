import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';
import '../../../extensions/json_extension.dart';

part 'repayment_model.g.dart';

@HiveType(typeId: 7)
class RepaymentModel extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final int farmerId;
  
  @HiveField(2)
  final String farmerName;
  
  @HiveField(3)
  final double amount;
  
  @HiveField(4)
  final String paymentMethod;
  
  @HiveField(5)
  final String? reference;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final String? commodityName;
  
  @HiveField(8)
  final double? commodityRate;
  
  @HiveField(9)
  final double? commodityKg;
  
  @HiveField(10)
  final bool isSynced;
  
  @HiveField(11)
  final List<Map<String, dynamic>>? debtAllocations;

  const RepaymentModel({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.amount,
    required this.paymentMethod,
    this.reference,
    required this.createdAt,
    this.commodityName,
    this.commodityRate,
    this.commodityKg,
    this.isSynced = false,
    this.debtAllocations,
  });

  factory RepaymentModel.fromJson(Map<String, dynamic> json) {
    return RepaymentModel(
      id: json.jsonInt('id'),
      farmerId: json.jsonInt('farmer_id'),
      farmerName: json['farmer']?['name'] as String? ?? '',
      amount: json.jsonDouble('amount'),
      paymentMethod: json['payment_method'] as String,
      reference: json['reference'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      commodityName: json['commodity_name'] as String?,
      commodityRate: json.jsonDoubleOrNull('commodity_rate'),
      commodityKg: json.jsonDoubleOrNull('commodity_kg'),
      isSynced: json['is_synced'] as bool? ?? true,
      debtAllocations: (json['debts'] as List<dynamic>?)
          ?.map((e) => {
            'debt_id': e['id'] ?? e['pivot']?['debt_id'],
            'amount_applied': e['pivot']?['amount_applied'],
            'remaining_balance': e['balance'],
          })
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmer_id': farmerId,
      'farmer_name': farmerName,
      'amount': amount,
      'payment_method': paymentMethod,
      'reference': reference,
      'created_at': createdAt.toIso8601String(),
      'commodity_name': commodityName,
      'commodity_rate': commodityRate,
      'commodity_kg': commodityKg,
      'is_synced': isSynced,
      'debt_allocations': debtAllocations,
    };
  }

  @override
  List<Object?> get props => [
    id, farmerId, farmerName, amount, paymentMethod,
    reference, createdAt, commodityName, commodityRate,
    commodityKg, isSynced, debtAllocations,
  ];
}
