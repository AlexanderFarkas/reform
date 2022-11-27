part of '../reform.dart';

abstract class _RefieldWithParent<TOriginal, TSanitized, TParentSanitized>
    extends Refield<TOriginal, TSanitized> {
  final Refield<TOriginal, TParentSanitized>? parent;

  _RefieldWithParent({required TOriginal originalValue, required this.parent})
      : super(originalValue);

  @nonVirtual
  @protected
  late final TParentSanitized parentSanitizedValue = parent != null
      ? parent!.sanitizedValue
      : originalValue as TParentSanitized;

  @nonVirtual
  @protected
  late final isParentValid = parent?.isValid ?? true;
}

class _ValidatorRefield<T, TParentSanitized>
    extends _RefieldWithParent<T, TParentSanitized, TParentSanitized> {
  final Validator<TParentSanitized> _validator;
  _ValidatorRefield({
    required super.originalValue,
    required super.parent,
    required Validator<TParentSanitized> validator,
  }) : _validator = validator;

  @override
  late final String? displayError =
      parent?.displayError ?? _validator(sanitizedValue);

  @override
  late final bool isValid = isParentValid && displayError == null;

  @override
  late final TParentSanitized sanitizedValue = parentSanitizedValue;
}

class _SanitizerRefield<T, TSanitized, TParentSanitized>
    extends _RefieldWithParent<T, TSanitized, TParentSanitized> {
  final Sanitizer<TParentSanitized, TSanitized> _sanitizer;

  _SanitizerRefield({
    required super.originalValue,
    required super.parent,
    required Sanitizer<TParentSanitized, TSanitized> sanitizer,
  }) : _sanitizer = sanitizer;

  @override
  late final displayError = parent?.displayError;

  @override
  late final isValid = isParentValid;

  late final TSanitized _sanitizedValue = _sanitizer(parentSanitizedValue);

  @override
  TSanitized get sanitizedValue {
    if (isValid) {
      return _sanitizedValue;
    } else {
      throw StateError(
          "`sanitizedValue` cannot be accessed, when `isValid == false`");
    }
  }
}
