import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';
import '../../../extensions/json_extension.dart';

part 'debt_model.g.dart';

@HiveType(typeId: 6)
class DebtModel extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final int? transactionId;
  
  @HiveField(2)
  final int farmerId;
  
  @HiveField(3)
  final String farmerName;
  
  @HiveField(4)
  final double principal;
  
  @HiveField(5)
  final double interestRate;
  
  @HiveField(6)
  final double totalDue;
  
  @HiveField(7)
  final double amountRepaid;
  
  @HiveField(8)
  final double balance;
  
  @HiveField(9)
  final String status;
  
  @HiveField(10)
  final DateTime createdAt;
  
  @HiveField(11)
  final DateTime? updatedAt;
  
  @HiveField(12)
  final String? reference;

  const DebtModel({
    required this.id,
    this.transactionId,
    required this.farmerId,
    required this.farmerName,
    required this.principal,
    required this.interestRate,
    required this.totalDue,
    required this.amountRepaid,
    required this.balance,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.reference,
  });

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json.jsonInt('id'),
      transactionId: json.jsonIntOrNull('transaction_id'),
      farmerId: json.jsonInt('farmer_id'),
      farmerName: json['farmer']?['name'] as String? ?? '',
      principal: json.jsonDouble('principal'),
      interestRate: json.jsonDouble('interest_rate'),
      totalDue: json.jsonDouble('total_due'),
      amountRepaid: json.jsonDouble('amount_repaid'),
      balance: json.jsonDouble('balance'),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      reference: json['reference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'farmer_id': farmerId,
      'farmer_name': farmerName,
      'principal': principal,
      'interest_rate': interestRate,
      'total_due': totalDue,
      'amount_repaid': amountRepaid,
      'balance': balance,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'reference': reference,
    };
  }

  @override
  List<Object?> get props => [
    id, transactionId, farmerId, farmerName, principal,
    interestRate, totalDue, amountRepaid, balance, status,
    createdAt, updatedAt, reference,
  ];
}
