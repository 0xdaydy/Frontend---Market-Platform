import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';

part 'transaction_item_model.g.dart';

@HiveType(typeId: 4)
class TransactionItemModel extends Equatable {
  @HiveField(0)
  final int? id;
  
  @HiveField(1)
  final int productId;
  
  @HiveField(2)
  final String productName;
  
  @HiveField(3)
  final int quantity;
  
  @HiveField(4)
  final double unitPrice;
  
  @HiveField(5)
  final double lineTotal;

  const TransactionItemModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      id: json['id'] as int?,
      productId: json['product_id'] as int,
      productName: json['product_name'] as String? ?? json['product']?['name'] as String? ?? '',
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      lineTotal: (json['line_total'] as num?)?.toDouble() ?? 
          ((json['quantity'] as num) * (json['unit_price'] as num)).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'line_total': lineTotal,
    };
  }

  @override
  List<Object?> get props => [id, productId, productName, quantity, unitPrice, lineTotal];
}
