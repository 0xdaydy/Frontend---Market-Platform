import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';

part 'product_model.g.dart';

@HiveType(typeId: 3)
class ProductModel extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String? description;
  
  @HiveField(3)
  final double priceFcfa;
  
  @HiveField(4)
  final int categoryId;
  
  @HiveField(5)
  final String? categoryName;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.priceFcfa,
    required this.categoryId,
    this.categoryName,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      priceFcfa: (json['price_fcfa'] as num).toDouble(),
      categoryId: json['category_id'] as int,
      categoryName: json['category']?['name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_fcfa': priceFcfa,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id, name, description, priceFcfa, categoryId, categoryName, createdAt, updatedAt
  ];
}
