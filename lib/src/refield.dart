part of '../reform.dart';

typedef Validator<T> = String? Function(T value);
typedef Sanitizer<T, TSanitized> = TSanitized Function(T value);

class Reform {
  static bool validate(List<SanitizableRefield> fields) =>
      fields.every((element) => element.isValid);

  static bool defaultShouldShowError<T>(FieldBuilderState<T> state) {
    return true;
  }
}

typedef DisplayErrorFn<T> = bool Function(T value);

// class Refield<T> {
//   final Refield<T>? _parent;

//   final T value;
//   final Validator<T> _validate;

//   Refield({
//     required this.value,
//     required Validator<T> validate,
//     Refield<T>? parent,
//   })  : _parent = parent,
//         _validate = validate;

//   /// Use it in UI and consider field valid for end user, if [displayError] == null
//   late final String? displayError = _parent?.displayError ?? _validate(value);

//   /// You should only use [isValid] inside your logic
//   /// It could be overridden to prevent submission
//   late final bool isValid = isParentValid && displayError == null;

//   Refield<T> validate(Validator<T> validator) => Refield(
//         value: value,
//         validate: validator,
//         parent: this,
//       );

//   @nonVirtual
//   @protected
//   late final bool isParentValid = _parent?.isValid ?? true;
// }

abstract class Refield<TOriginal> {
  abstract final TOriginal value;

  /// Use when you want to display an error in user-facing code
  /// Better use [builder] extension method
  abstract final String? displayError;

  /// Use when you're deciding whether form is submittable.
  /// E.g. in your view model
  abstract final bool isValid;
}

abstract class SanitizableRefield<TOriginal, TSanitized> extends Refield<TOriginal> {
  @override
  late final value = originalValue;

  abstract final TOriginal originalValue;
  abstract final TSanitized sanitizedValue;

  SanitizableRefield<TOriginal, T> as<T>() => sanitize((value) => value as T);
  SanitizableRefield<TOriginal, T> sanitize<T>(Sanitizer<TSanitized, T> sanitizer);
  SanitizableRefield<TOriginal, TSanitized> validate(Validator<TSanitized> sanitizer);
}

extension RefieldX<T> on T {
  SanitizableRefield<T, T> validate(Validator<T> validator) => _ValidatorRefield(
        originalValue: this,
        validator: validator,
        parent: null,
      );

  SanitizableRefield<T, TSanitized> sanitize<TSanitized>(Sanitizer<T, TSanitized> sanitizer) =>
      _SanitizerRefield(
        originalValue: this,
        sanitizer: sanitizer,
        parent: null,
      );
}

extension FlutterRefieldX<T> on Refield<T> {
  Widget builder({
    Key? key,
    ShowErrorPredicate? shouldShowError,
    required FieldWidgetBuilder<T> builder,
  }) =>
      RefieldBuilder<T>(
        key: key,
        field: this,
        shouldShowError: shouldShowError,
        builder: builder,
      );
}

extension FlutterTextRefieldX on Refield<String> {
  Widget builder({
    Key? key,
    TextEditingController? controller,
    ShowErrorPredicate? shouldShowError,
    required ValueChanged<String> onChanged,
    required TextRefieldWidgetBuilder builder,
  }) =>
      TextRefieldBuilder(
        key: key,
        field: this,
        controller: controller,
        builder: builder,
        shouldShowError: shouldShowError,
        onChanged: onChanged,
      );
}

abstract class _Refield<TOriginal, TSanitized, TParentSanitized>
    extends SanitizableRefield<TOriginal, TSanitized> {
  @override
  final TOriginal originalValue;
  final _Refield<TOriginal, TParentSanitized, dynamic>? parent;

  _Refield({required this.originalValue, required this.parent});

  @nonVirtual
  @protected
  late final bool isParentValid = parent?.isValid ?? true;

  @nonVirtual
  @protected
  late final TParentSanitized parentSanitizedValue =
      parent != null ? parent!.sanitizedValue : originalValue as TParentSanitized;

  @override
  _Refield<TOriginal, TSanitized, TSanitized> validate(Validator<TSanitized> validator) =>
      _ValidatorRefield(
        originalValue: originalValue,
        validator: validator,
        parent: this,
      );

  @override
  _Refield<TOriginal, T, TSanitized> sanitize<T>(Sanitizer<TSanitized, T> sanitizer) =>
      _SanitizerRefield(
        originalValue: originalValue,
        sanitizer: sanitizer,
        parent: this,
      );
}

class _ValidatorRefield<T, TParentSanitized>
    extends _Refield<T, TParentSanitized, TParentSanitized> {
  final Validator<TParentSanitized> _validator;
  _ValidatorRefield({
    required super.originalValue,
    required super.parent,
    required Validator<TParentSanitized> validator,
  }) : _validator = validator;

  @override
  late final String? displayError = parent?.displayError ?? _validator(sanitizedValue);

  @override
  late final bool isValid = isParentValid && displayError == null;

  @override
  late final TParentSanitized sanitizedValue = parentSanitizedValue;
}

class _SanitizerRefield<T, TSanitized, TParentSanitized>
    extends _Refield<T, TSanitized, TParentSanitized> {
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
      throw StateError("`sanitizedValue` cannot be accessed, when `isValid == false`");
    }
  }
}
