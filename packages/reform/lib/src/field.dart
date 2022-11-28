part of '../reform.dart';

abstract class Field<T> {
  final T value;

  Field(this.value);

  String? get error;

  FieldStatus get status {
    if (error != null) {
      return FieldStatus.invalid;
    } else {
      return FieldStatus.valid;
    }
  }

  bool get isValid => status == FieldStatus.valid;
  bool get isPending => status == FieldStatus.pending;
  bool get isInvalid => status == FieldStatus.invalid;
}

abstract class SanitizedField<TOriginal, TSanitized> extends Field<TOriginal> {
  SanitizedField(super.value);

  TSanitized get sanitizedValue;
}
