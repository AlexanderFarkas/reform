part of '../reform.dart';

class Reform {
  static bool validate(List<Field> fields) => fields.every((element) => element.isValid);
}