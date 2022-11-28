part of '../reform.dart';

class Reform {
  Reform._();

  static bool isValid(List<Field> fields) =>
      fields.every((field) => field.isValid);
}
