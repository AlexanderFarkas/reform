part of '../reform.dart';

class Reform {
  Reform._();

  static bool isValid(List<Field> fields) =>
      fields.every((field) => field.isValid);
}

extension RefieldX<T> on T {
  Refield<T, T> refield() => _ValidRefield(this);
}
