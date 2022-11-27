part of '../reform.dart';

typedef Validator<T> = String? Function(T value);
typedef Sanitizer<T, TSanitized> = TSanitized Function(T value);

abstract class Refield<TOriginal, TSanitized> extends Field<TOriginal> {
  final TOriginal originalValue;

  Refield(this.originalValue);

  @override
  late final value = originalValue;

  /// throws `StateError`, if called while `isValid == false`
  /// Implementers should respect that.
  TSanitized get sanitizedValue;

  Refield<TOriginal, T> as<T>() => sanitize((value) => value as T);

  Refield<TOriginal, TSanitized> validate(Validator<TSanitized> validator) =>
      _ValidatorRefield<TOriginal, TSanitized>(
        originalValue: originalValue,
        validator: validator,
        parent: this,
      );

  Refield<TOriginal, T> sanitize<T>(Sanitizer<TSanitized, T> sanitizer) =>
      _SanitizerRefield<TOriginal, T, TSanitized>(
        originalValue: originalValue,
        sanitizer: sanitizer,
        parent: this,
      );
}

extension RefieldX<T> on T {
  Refield<T, T> validate(Validator<T> validator) => _ValidatorRefield(
        originalValue: this,
        validator: validator,
        parent: null,
      );

  Refield<T, TSanitized> sanitize<TSanitized>(Sanitizer<T, TSanitized> sanitizer) =>
      _SanitizerRefield(
        originalValue: this,
        sanitizer: sanitizer,
        parent: null,
      );
}
