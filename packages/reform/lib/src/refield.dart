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

  Stream<Refield<TOriginal, TSanitized>> validateAsync(
    TOriginal value, {
    required Future<String?> Function(TOriginal value) validator,
  }) async* {
    if (this.isInvalid) {
      yield this;
      return;
    }

    yield _StatusRefield.pending(parent: this);
    final error = await validator(value);
    yield this.validate((value) => error);
  }
}

class ValidRefield<T> extends Refield<T, T> {
  ValidRefield(super.value);

  @override
  String? get error => null;

  @override
  T get sanitizedValue => value;
}
