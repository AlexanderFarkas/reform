part of '../reform.dart';

class Reform {
  static bool isEnabled(List<Field> fields) =>
      fields.every((element) => element.displayError == null);
  static bool isValid(List<Field> fields) =>
      fields.every((element) => element.isValid);
}
