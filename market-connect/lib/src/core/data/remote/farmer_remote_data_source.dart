import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../models/models.dart';

/// Remote data source for farmer API operations.
class FarmerRemoteDataSource {
  final DioService _dio = DioService.instance;

  FutureEither<List<FarmerModel>> getFarmers() async {
    final result = await _dio.get('farmers');
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
        final farmers = list
            .map((e) => FarmerModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(farmers);
      } catch (e, st) {
        AppLogger.error('FarmerRemoteDataSource: Failed to parse getFarmers: $e', [e, st]);
        return left(ServerFailure('Failed to parse farmers: $e', error: e));
      }
    });
  }

  FutureEither<FarmerModel> getFarmer(int id) async {
    final result = await _dio.get('farmers/$id');
    return result.flatMap((response) {
      try {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          return left(const ServerFailure('Invalid response format: expected object'));
        }
        final farmer = FarmerModel.fromJson(data['data'] ?? data);
        return right(farmer);
      } catch (e, st) {
        AppLogger.error('FarmerRemoteDataSource: Failed to parse getFarmer: $e', [e, st]);
        return left(ServerFailure('Failed to parse farmer: $e', error: e));
      }
    });
  }

  FutureEither<FarmerModel> createFarmer(Map<String, dynamic> data) async {
    final result = await _dio.post('farmers', data: data);
    return result.flatMap((response) {
      try {
        final responseData = response.data;
        if (responseData is! Map<String, dynamic>) {
          return left(const ServerFailure('Invalid response format: expected object'));
        }
        final farmer = FarmerModel.fromJson(responseData['data'] ?? responseData);
        return right(farmer);
      } catch (e, st) {
        AppLogger.error('FarmerRemoteDataSource: Failed to parse createFarmer: $e', [e, st]);
        return left(ServerFailure('Failed to parse created farmer: $e', error: e));
      }
    });
  }

  FutureEither<List<DebtModel>> getFarmerDebts(int farmerId) async {
    final result = await _dio.get('farmers/$farmerId/debts');
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
        final debts = list
            .map((e) => DebtModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(debts);
      } catch (e, st) {
        AppLogger.error('FarmerRemoteDataSource: Failed to parse getFarmerDebts: $e', [e, st]);
        return left(ServerFailure('Failed to parse debts: $e', error: e));
      }
    });
  }

  FutureEither<List<TransactionModel>> getFarmerTransactions(int farmerId) async {
    final result = await _dio.get('farmers/$farmerId/transactions');
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
        AppLogger.error('FarmerRemoteDataSource: Failed to parse getFarmerTransactions: $e', [e, st]);
        return left(ServerFailure('Failed to parse transactions: $e', error: e));
      }
    });
  }
}
