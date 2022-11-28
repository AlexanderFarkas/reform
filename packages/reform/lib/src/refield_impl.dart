part of '../reform.dart';

abstract class _RefieldWithParent<TOriginal, TSanitized, TParentSanitized>
    extends Refield<TOriginal, TSanitized> {
  final Refield<TOriginal, TParentSanitized> parent;

  _RefieldWithParent(super.value, {required this.parent});

  @override
  FieldStatus get status {
    final parentStatus = parent.status;
    if (parentStatus == FieldStatus.valid) {
      return super.status;
    }

    return parentStatus;
  }
}

class _ValidatorRefield<T, TParentSanitized>
    extends _RefieldWithParent<T, TParentSanitized, TParentSanitized> {
  final Validator<TParentSanitized> _validator;
  _ValidatorRefield(
    super.value, {
    required super.parent,
    required Validator<TParentSanitized> validator,
  }) : _validator = validator;

  @override
  late final String? error = parent.error ?? _validator(sanitizedValue);

  @override
  late final TParentSanitized sanitizedValue = parent.sanitizedValue;
}

class _SanitizerRefield<T, TSanitized, TParentSanitized>
    extends _RefieldWithParent<T, TSanitized, TParentSanitized> {
  final Sanitizer<TParentSanitized, TSanitized> _sanitizer;

  _SanitizerRefield(
    super.value, {
    required super.parent,
    required Sanitizer<TParentSanitized, TSanitized> sanitizer,
  }) : _sanitizer = sanitizer;

  @override
  late final error = parent.error;
  late final TSanitized _sanitizedValue = _sanitizer(parent.sanitizedValue);

  @override
  TSanitized get sanitizedValue {
    if (isValid) {
      return _sanitizedValue;
    } else {
      throw StateError(
        "`sanitizedValue` cannot be accessed, when `isValid == false`",
      );
    }
  }
}

class _StatusRefield<TOriginal, TParentSanitized>
    extends _RefieldWithParent<TOriginal, TParentSanitized, TParentSanitized> {
  final String? _error;

  @override
  final FieldStatus status;

  _StatusRefield.error(
    super.value, {
    required String error,
    required super.parent,
  })  : _error = error,
        status = FieldStatus.invalid;

  _StatusRefield.pending(super.value, {required super.parent})
      : _error = null,
        status = FieldStatus.pending;

  @override
  TParentSanitized get sanitizedValue => parent.sanitizedValue;

  /// If we provide error, we want it to be displayed.
  /// So it's more reasonable here to show own [error] over [parent.error]
  @override
  String? get error => _error ?? parent.error;
}
