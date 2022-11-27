part of '../reform.dart';

abstract class Field<T> {
  T get value;

  /// Use when you want to display an error in user-facing code
  /// Better use [builder] extension method
  String? get displayError;

  /// Use when you're deciding whether form is submittable.
  /// E.g. in your view model
  bool get isValid;
}