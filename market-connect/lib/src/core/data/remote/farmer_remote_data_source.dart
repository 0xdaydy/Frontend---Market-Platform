import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../models/models.dart';

/// Remote data source for farmer API operations.
class FarmerRemoteDataSource {
  final DioService _dio = DioService.instance;

  FutureEither<List<FarmerModel>> getFarmers() async {
    final result = await _dio.get('/farmers');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] ?? data) as List<dynamic>;
      final farmers = list
          .map((e) => FarmerModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(farmers);
    });
  }

  FutureEither<FarmerModel> getFarmer(int id) async {
    final result = await _dio.get('/farmers/$id');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final farmer = FarmerModel.fromJson(data['data'] ?? data);
      return right(farmer);
    });
  }

  FutureEither<FarmerModel> createFarmer(Map<String, dynamic> data) async {
    final result = await _dio.post('/farmers', data: data);
    return result.flatMap((response) {
      final responseData = response.data as Map<String, dynamic>;
      final farmer = FarmerModel.fromJson(responseData['data'] ?? responseData);
      return right(farmer);
    });
  }

  FutureEither<List<DebtModel>> getFarmerDebts(int farmerId) async {
    final result = await _dio.get('/farmers/$farmerId/debts');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] ?? data) as List<dynamic>;
      final debts = list
          .map((e) => DebtModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(debts);
    });
  }

  FutureEither<List<TransactionModel>> getFarmerTransactions(int farmerId) async {
    final result = await _dio.get('/farmers/$farmerId/transactions');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] ?? data) as List<dynamic>;
      final transactions = list
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(transactions);
    });
  }
}
