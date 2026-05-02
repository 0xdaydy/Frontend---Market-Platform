import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';

part 'farmer_model.g.dart';

@HiveType(typeId: 1)
class FarmerModel extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String cardId;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String? phone;
  
  @HiveField(4)
  final String? village;
  
  @HiveField(5)
  final double creditLimit;
  
  @HiveField(6)
  final double creditBalanceFcfa;
  
  @HiveField(7)
  final DateTime createdAt;
  
  @HiveField(8)
  final DateTime? updatedAt;

  const FarmerModel({
    required this.id,
    required this.cardId,
    required this.name,
    this.phone,
    this.village,
    required this.creditLimit,
    required this.creditBalanceFcfa,
    required this.createdAt,
    this.updatedAt,
  });

  factory FarmerModel.fromJson(Map<String, dynamic> json) {
    return FarmerModel(
      id: json['id'] as int,
      cardId: json['card_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      village: json['village'] as String?,
      creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 50000.0,
      creditBalanceFcfa: (json['credit_balance_fcfa'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_id': cardId,
      'name': name,
      'phone': phone,
      'village': village,
      'credit_limit': creditLimit,
      'credit_balance_fcfa': creditBalanceFcfa,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  FarmerModel copyWith({
    int? id,
    String? cardId,
    String? name,
    String? phone,
    String? village,
    double? creditLimit,
    double? creditBalanceFcfa,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FarmerModel(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      village: village ?? this.village,
      creditLimit: creditLimit ?? this.creditLimit,
      creditBalanceFcfa: creditBalanceFcfa ?? this.creditBalanceFcfa,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id, cardId, name, phone, village, 
    creditLimit, creditBalanceFcfa, createdAt, updatedAt
  ];
}
