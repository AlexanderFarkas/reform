part of '../reform.dart';

typedef Validator<T> = String? Function(T value);

class Reform {
  static bool validate(List<Refield<dynamic>> fields) =>
      fields.every((element) => element.isValid);

  static bool defaultShouldShowError<T>(FieldBuilderState<T> state) {
    return true;
  }
}

typedef DisplayErrorFn<T> = bool Function(T value);

class Refield<T> {
  final Refield<T>? _parent;

  final T value;
  final Validator<T> _validate;

  Refield({
    required this.value,
    required Validator<T> validate,
    Refield<T>? parent,
  })  : _parent = parent,
        _validate = validate;

  /// Use it in UI and consider field valid for end user, if [displayError] == null
  late final String? displayError = _parent?.displayError ?? _validate(value);

  /// You should only use [isValid] inside your logic
  /// It could be overridden to prevent submission
  late final bool isValid = isParentValid && displayError == null;

  Refield<T> validate(Validator<T> validator) => Refield(
        value: value,
        validate: validator,
        parent: this,
      );

  @nonVirtual
  @protected
  late final bool isParentValid = _parent?.isValid ?? true;
}

extension RefieldX<T> on T {
  Refield<T> validate(Validator<T> validator) => Refield(
        value: this,
        validate: validator,
      );
}

extension FlutterRefieldX<T> on Refield<T> {
  Widget builder({
    Key? key,
    required FieldWidgetBuilder<T> builder,
  }) =>
      RefieldBuilder<T>(
        key: key,
        field: this,
        builder: builder,
      );
}

extension FlutterTextRefieldX on Refield<String> {
  Widget builder({
    Key? key,
    TextEditingController? controller,
    required TextRefieldWidgetBuilder builder,
  }) =>
      TextRefieldBuilder(
        key: key,
        field: this,
        controller: controller,
        builder: builder,
      );
}
