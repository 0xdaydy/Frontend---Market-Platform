import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';
import '../../../extensions/json_extension.dart';

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
      id: json.jsonIntOrNull('id'),
      productId: json.jsonInt('product_id'),
      productName: json['product_name'] as String? ?? json['product']?['name'] as String? ?? '',
      quantity: json.jsonInt('quantity'),
      unitPrice: json.jsonDouble('unit_price'),
      lineTotal: json.jsonDoubleOrNull('line_total') ??
          (json.jsonInt('quantity') * json.jsonDouble('unit_price')).toDouble(),
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
