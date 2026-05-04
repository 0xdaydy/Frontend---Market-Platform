import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';
import '../models/models.dart';

/// Remote data source for repayment API operations.
class RepaymentRemoteDataSource {
  final DioService _dio = DioService.instance;

  FutureEither<List<RepaymentModel>> getRepayments() async {
    final result = await _dio.get('/repayments');
    return result.flatMap((response) {
      try {
        final list = switch (response.data) {
          final List<dynamic> l => l,
          final Map<String, dynamic> m =>
            m.jsonList('data', fallbackKeys: const ['repayments']),
          _ => throw const FormatException('Expected Map or List response'),
        };
        final repayments = list
            .map((e) => RepaymentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(repayments);
      } catch (e, st) {
        AppLogger.error(
            'RepaymentRemoteDataSource: Failed to parse getRepayments: $e',
            [e, st]);
        return left(ServerFailure('Failed to parse repayments: $e', error: e));
      }
    });
  }

  FutureEither<RepaymentModel> createRepayment(
      Map<String, dynamic> data) async {
    final result = await _dio.post('/repayments', data: data);
    return result.flatMap((response) {
      try {
        final responseData = response.data;
        if (responseData is! Map<String, dynamic>) {
          return left(
              const ServerFailure('Invalid response format: expected object'));
        }
        final repayment =
            RepaymentModel.fromJson(responseData['data'] ?? responseData);
        return right(repayment);
      } catch (e, st) {
        AppLogger.error(
            'RepaymentRemoteDataSource: Failed to parse createRepayment: $e',
            [e, st]);
        return left(
            ServerFailure('Failed to parse created repayment: $e', error: e));
      }
    });
  }
}
