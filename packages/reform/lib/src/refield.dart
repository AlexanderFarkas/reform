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

  static Stream<Refield<T, TSanitized>> validateAsync<T, TSanitized>(
    T value, {
    required Future<String?> Function(T value) validator,
    Refield<T, TSanitized> Function(Refield<T, T> value)? converter,
  }) async* {
    Refield<T, TSanitized> applyConverter(Refield<T, T> value) =>
        converter != null ? converter(value) : value as Refield<T, TSanitized>;

    final initial = applyConverter(refield(value));
    final isInvalid = initial.status == FieldStatus.invalid;
    final shouldContinue = !isInvalid;
    yield applyConverter(refield(value, isPending: shouldContinue));

    if (shouldContinue) {
      final error = await validator(value);
      yield applyConverter(refield(value)).validate((value) => error);
    }
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
