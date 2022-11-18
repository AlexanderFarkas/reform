part of '../reform.dart';

typedef Validator<T> = bool Function(T value);

class Reform {
  static validate(List<Refield<dynamic>> fields) =>
      fields.every((element) => element.isValid);

  static defaultShouldShowError<T>(
      Refield<T> field, FieldBuilderState<T> state) {
    return true;
  }
}

class Refield<T> {
  final Refield<T>? _parent;
  final String _errorText;
  final T value;
  final Validator<T> validator;

  Refield(
    this._parent,
    this._errorText,
    this.value,
    this.validator,
  );

  late final String? error =
      _parent?.error ?? (validator(value) ? null : _errorText);
  late final isValid = error == null;

  Refield<T> then(Validator<T> validator, String errorText) =>
      Refield(this, errorText, value, validator);
}

extension RefieldX<T> on T {
  Refield<T> validate(Validator<T> validator, String errorText) =>
      Refield(null, errorText, this, validator);
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
