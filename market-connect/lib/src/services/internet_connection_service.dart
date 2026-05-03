import '../imports/imports.dart';

class InternetConnectionService {
  InternetConnectionService();

  final InternetConnection internetConnection = InternetConnection();

  Future<bool> hasConnection() async =>
      await internetConnection.hasInternetAccess;

  /// Stream of connectivity status changes.
  Stream<bool> get onStatusChange => internetConnection.onStatusChange.map(
        (status) => status == InternetStatus.connected,
      );
}
