import 'package:equatable/equatable.dart';
import '../../../extensions/json_extension.dart';

class CommodityModel extends Equatable {
  final int id;
  final String name;
  final String unit;
  final double rateFcfaPerUnit;

  const CommodityModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.rateFcfaPerUnit,
  });

  factory CommodityModel.fromJson(Map<String, dynamic> json) {
    return CommodityModel(
      id: json.jsonInt('id'),
      name: json['name'] as String,
      unit: json['unit'] as String,
      rateFcfaPerUnit: json.jsonDouble('rate_fcfa_per_unit'),
    );
  }

  @override
  List<Object?> get props => [id, name, unit, rateFcfaPerUnit];
}
