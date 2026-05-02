import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../models/models.dart';

/// Remote data source for transaction API operations.
class TransactionRemoteDataSource {
  final DioService _dio = DioService.instance;

  FutureEither<List<TransactionModel>> getTransactions() async {
    final result = await _dio.get('/transactions');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] ?? data) as List<dynamic>;
      final transactions = list
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(transactions);
    });
  }

  FutureEither<TransactionModel> getTransaction(int id) async {
    final result = await _dio.get('/transactions/$id');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final transaction = TransactionModel.fromJson(data['data'] ?? data);
      return right(transaction);
    });
  }

  FutureEither<TransactionModel> createTransaction(Map<String, dynamic> data) async {
    final result = await _dio.post('/transactions', data: data);
    return result.flatMap((response) {
      final responseData = response.data as Map<String, dynamic>;
      final transaction = TransactionModel.fromJson(responseData['data'] ?? responseData);
      return right(transaction);
    });
  }

  FutureEither<Map<String, dynamic>> validateTransaction(Map<String, dynamic> data) async {
    final result = await _dio.post('/transactions/validate', data: data);
    return result.flatMap((response) {
      final responseData = response.data as Map<String, dynamic>;
      return right(responseData['data'] ?? responseData);
    });
  }
}
