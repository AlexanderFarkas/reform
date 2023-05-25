part of '../reform.dart';

typedef Validator<T> = String? Function(T value);
typedef Sanitizer<T, TSanitized> = TSanitized Function(T value);

enum FieldStatus {
  valid,
  invalid,
  pending,
}

abstract class Refield<TOriginal, TSanitized>
    extends SanitizedField<TOriginal, TSanitized> {
  Refield(super.value);

  Refield<TOriginal, TSanitized> validate(Validator<TSanitized> validator) =>
      _ValidatorRefield<TOriginal, TSanitized>(
        validator: validator,
        parent: this,
      );

  Refield<TOriginal, T> sanitize<T>(Sanitizer<TSanitized, T> sanitizer) =>
      _SanitizerRefield<TOriginal, T, TSanitized>(
        sanitizer: sanitizer,
        parent: this,
      );

  Refield<TOriginal, T> as<T>() => sanitize((value) => value as T);

  static Stream<Refield<T, T>> validateAsync<T>(
    T value, {
    required Future<String?> Function(T value) validator,
  }) async* {
    yield refield(value, isPending: true);
    final error = await validator(value);
    yield refield(value).validate((value) => error);
  }
}

class _StatusRefield<T> extends Refield<T, T> {
  _StatusRefield.valid(super.value) : status = FieldStatus.valid;

  _StatusRefield.pending(super.value) : status = FieldStatus.pending;

  @override
  final FieldStatus status;

  @override
  String? get error => null;

  @override
  T get sanitizedValue => value;
}
