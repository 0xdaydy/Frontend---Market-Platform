import 'package:fpdart/fpdart.dart';


/// Extension methods on [Either] to reduce boilerplate in Riverpod providers.
extension EitherX<L extends Object, R> on Either<L, R> {
  /// Unwraps the Either: returns the value on Right, throws [L] on Left.
  ///
  /// Usage:
  /// ```dart
  /// final myProvider = FutureProvider<X>((ref) async {
  ///   return (await repo.getX()).getOrThrow;
  /// });
  /// ```
  R get getOrThrow => fold(
        (failure) => throw failure,
        (value) => value,
      );
}
