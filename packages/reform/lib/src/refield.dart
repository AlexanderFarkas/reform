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

  Refield<TOriginal, TSanitized> withError(String error) =>
      _StatusRefield.error(
        error: error,
        parent: this,
      );

  Refield<TOriginal, TSanitized> pending() =>
      _StatusRefield.pending(parent: this);
}

class _ValidRefield<T> extends Refield<T, T> {
  _ValidRefield(super.value);

  @override
  String? get error => null;

  @override
  T get sanitizedValue => value;
}
