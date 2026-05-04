import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';
import '../models/models.dart';

/// Remote data source for commodity API operations.
class CommodityRemoteDataSource {
  final DioService _dio = DioService.instance;

  FutureEither<List<CommodityModel>> getCommodities() async {
    final result = await _dio.get('/commodities');
    return result.flatMap((response) {
      try {
        final list = switch (response.data) {
          final List<dynamic> l => l,
          final Map<String, dynamic> m =>
            m.jsonList('data', fallbackKeys: const ['commodities']),
          _ => throw const FormatException('Expected Map or List response'),
        };
        final commodities = list
            .map((e) => CommodityModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(commodities);
      } catch (e, st) {
        AppLogger.error(
            'CommodityRemoteDataSource: Failed to parse getCommodities: $e',
            [e, st]);
        return left(
            ServerFailure('Failed to parse commodities: $e', error: e));
      }
    });
  }
}
