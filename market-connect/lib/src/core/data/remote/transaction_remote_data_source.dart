import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../models/models.dart';

/// Remote data source for transaction API operations.
class TransactionRemoteDataSource {
  final DioService _dio = DioService.instance;

  FutureEither<List<TransactionModel>> getTransactions() async {
    final result = await _dio.get('transactions');
    return result.flatMap((response) {
      try {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          return left(const ServerFailure('Invalid response format: expected object'));
        }
        final list = data['data'] ?? data;
        if (list is! List) {
          return left(const ServerFailure('Invalid response format: expected list'));
        }
        final transactions = list
            .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(transactions);
      } catch (e, st) {
        AppLogger.error('TransactionRemoteDataSource: Failed to parse getTransactions: $e', [e, st]);
        return left(ServerFailure('Failed to parse transactions: $e', error: e));
      }
    });
  }

  FutureEither<TransactionModel> getTransaction(int id) async {
    final result = await _dio.get('transactions/$id');
    return result.flatMap((response) {
      try {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          return left(const ServerFailure('Invalid response format: expected object'));
        }
        final transaction = TransactionModel.fromJson(data['data'] ?? data);
        return right(transaction);
      } catch (e, st) {
        AppLogger.error('TransactionRemoteDataSource: Failed to parse getTransaction: $e', [e, st]);
        return left(ServerFailure('Failed to parse transaction: $e', error: e));
      }
    });
  }

  FutureEither<TransactionModel> createTransaction(Map<String, dynamic> data) async {
    final result = await _dio.post('transactions', data: data);
    return result.flatMap((response) {
      try {
        final responseData = response.data;
        if (responseData is! Map<String, dynamic>) {
          return left(const ServerFailure('Invalid response format: expected object'));
        }
        final transaction = TransactionModel.fromJson(responseData['data'] ?? responseData);
        return right(transaction);
      } catch (e, st) {
        AppLogger.error('TransactionRemoteDataSource: Failed to parse createTransaction: $e', [e, st]);
        return left(ServerFailure('Failed to parse created transaction: $e', error: e));
      }
    });
  }

  FutureEither<Map<String, dynamic>> validateTransaction(Map<String, dynamic> data) async {
    final result = await _dio.post('transactions/validate', data: data);
    return result.flatMap((response) {
      try {
        final responseData = response.data;
        if (responseData is! Map<String, dynamic>) {
          return left(const ServerFailure('Invalid response format: expected object'));
        }
        return right(responseData['data'] ?? responseData);
      } catch (e, st) {
        AppLogger.error('TransactionRemoteDataSource: Failed to parse validateTransaction: $e', [e, st]);
        return left(ServerFailure('Failed to parse validation response: $e', error: e));
      }
    });
  }
}
