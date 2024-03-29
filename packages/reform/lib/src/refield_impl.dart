part of '../reform.dart';

abstract class _RefieldWithParent<TOriginal, TSanitized, TParentSanitized>
    extends Refield<TOriginal, TSanitized> {
  final Refield<TOriginal, TParentSanitized> parent;

  _RefieldWithParent({required this.parent}) : super(parent.value);

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
  _ValidatorRefield({
    required super.parent,
    required Validator<TParentSanitized> validator,
  }) {
    error = parent.error ?? validator(sanitizedValue);
  }

  @override
  late final String? error;

  @override
  late final TParentSanitized sanitizedValue = parent.sanitizedValue;
}

class _SanitizerRefield<T, TSanitized, TParentSanitized>
    extends _RefieldWithParent<T, TSanitized, TParentSanitized> {
  _SanitizerRefield({
    required super.parent,
    required Sanitizer<TParentSanitized, TSanitized> sanitizer,
  }) : error = parent.error {
    if (!isInvalid) {
      _sanitizedValue = sanitizer(parent.sanitizedValue);
    }
  }

  @override
  final String? error;
  late final TSanitized _sanitizedValue;

  @override
  TSanitized get sanitizedValue {
    if (isInvalid) {
      throw StateError(
        "`sanitizedValue` cannot be accessed, when `isInvalid == true`",
      );
    }
    return _sanitizedValue;
  }
}

class _StatusRefield<TOriginal, TParentSanitized>
    extends _RefieldWithParent<TOriginal, TParentSanitized, TParentSanitized> {
  final String? _error;

  @override
  final FieldStatus status;

  _StatusRefield.pending({required super.parent})
      : _error = null,
        status = FieldStatus.pending;

  @override
  TParentSanitized get sanitizedValue => parent.sanitizedValue;

  /// If we provide error, we want it to be displayed.
  /// So it's more reasonable here to show own [error] over [parent.error]
  @override
  String? get error => _error ?? parent.error;
}
