import 'package:flutter_test/flutter_test.dart';

import 'package:reform/reform.dart';

void main() {
  test("Basic", () {
    Refield<String, String> field(String value) => value
        .sanitize((value) => value.trim())
        .validate((value) => value.length == 12 ? null : "Error");

    final refield1 = field("  hello, world  ");
    final refield2 = field("hello, world");

    expect(refield1.displayError, equals(null));
    expect(refield2.sanitizedValue == refield1.sanitizedValue, isTrue);
    expect(refield2.originalValue == refield1.originalValue, isFalse);
  });

  test("Nullability", () {
    Refield field(String? value) => value
        .validate((value) => value == null ? "Can't be null" : null)
        .as<String>()
        .validate((value) => value.length > 8 ? null : "Error");

    final refield1 = field(null);
    expect(refield1.displayError, equals("Can't be null"));
    expect(() => refield1.sanitizedValue, throwsA(isA<StateError>()));

    final refield2 = field("hllo");
    expect(refield2.displayError, equals("Error"));
    expect(refield2.sanitizedValue, equals("hllo"));

    final refield3 = field("hello, world");
    expect(refield3.displayError, equals(null));
    expect(refield3.sanitizedValue, equals("hello, world"));
  });

  test("Several sanitizers", () {
    Refield<String?, int> field(String? value) => value
        .validate((value) => value == null ? "Can't be null" : null)
        .as<String>()
        .validate((value) => value.length > 8 ? null : "Too short")
        .sanitize((value) => int.tryParse(value))
        .validate((value) => value != null ? null : "It's not an int")
        .as<int>();

    final refield1 = field(null);
    expect(refield1.displayError, equals("Can't be null"));
    expect(() => refield1.sanitizedValue, throwsA(isA<StateError>()));

    final refield2 = field("hell");
    expect(refield2.displayError, equals("Too short"));
    expect(() => refield2.sanitizedValue, throwsA(isA<StateError>()));

    final refield3 = field("hello, world");
    expect(refield3.displayError, equals("It's not an int"));
    expect(() => refield3.sanitizedValue, throwsA(isA<StateError>()));

    final refield4 = field("1234567");
    expect(refield4.displayError, equals("Too short"));
    expect(() => refield4.sanitizedValue, throwsA(isA<StateError>()));

    final refield5 = field("123456789");
    expect(refield5.displayError, equals(null));
    expect(refield5.sanitizedValue, equals(123456789));
    expect(refield5.originalValue, equals("123456789"));
  });
}
