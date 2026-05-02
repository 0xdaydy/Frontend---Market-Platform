import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final int? parentId;
  
  @HiveField(3)
  final DateTime createdAt;
  
  @HiveField(4)
  final DateTime? updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.parentId,
    required this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      parentId: json['parent_id'] as int?,
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
      'parent_id': parentId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, parentId, createdAt, updatedAt];
}
