extension JsonMapExtension on Map<String, dynamic> {
  int jsonInt(String key) => switch (this[key]) {
    final int value => value,
    final String value => int.parse(value),
    _ => throw FormatException(
      'Expected int for "$key", got ${this[key]} (${this[key]?.runtimeType})',
    ),
  };

  int? jsonIntOrNull(String key) {
    final value = this[key];
    return value == null ? null : jsonInt(key);
  }

  double jsonDouble(String key) => switch (this[key]) {
    final double value => value,
    final int value => value.toDouble(),
    final String value => double.parse(value),
    _ => throw FormatException(
      'Expected double for "$key", got ${this[key]} (${this[key]?.runtimeType})',
    ),
  };

  double? jsonDoubleOrNull(String key) {
    final value = this[key];
    return value == null ? null : jsonDouble(key);
  }

  /// Extracts a list from a JSON map response.
  ///
  /// Tries [key] first, then each [fallbackKeys] in order.
  /// - Returns the list if the value is a [List].
  /// - Wraps a single [Map] in a list.
  /// - Returns an empty list when all tried keys are null.
  /// - Throws [FormatException] for any other type.
  List<dynamic> jsonList(String key, {List<String>? fallbackKeys}) {
    final keys = [key, ...(fallbackKeys ?? const <String>[])];
    for (final k in keys) {
      final value = this[k];
      if (value is List) return value;
      if (value is Map<String, dynamic>) return [value];
    }
    if (keys.every((k) => this[k] == null)) return [];
    throw FormatException(
      'Expected list for one of $keys, got mixed types',
    );
  }
}
