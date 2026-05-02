import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../models/models.dart';

/// Remote data source for repayment API operations.
class RepaymentRemoteDataSource {
  final DioService _dio = DioService.instance;

  FutureEither<List<RepaymentModel>> getRepayments() async {
    final result = await _dio.get('/repayments');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] ?? data) as List<dynamic>;
      final repayments = list
          .map((e) => RepaymentModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(repayments);
    });
  }

  FutureEither<RepaymentModel> createRepayment(Map<String, dynamic> data) async {
    final result = await _dio.post('/repayments', data: data);
    return result.flatMap((response) {
      final responseData = response.data as Map<String, dynamic>;
      final repayment = RepaymentModel.fromJson(responseData['data'] ?? responseData);
      return right(repayment);
    });
  }
}
