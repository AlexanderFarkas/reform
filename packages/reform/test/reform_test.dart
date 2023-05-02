import 'package:reform/reform.dart';
import 'package:test/test.dart';

void main() {
  test("Basic", () {
    Refield<String, String> field(String value) => refield(value)
        .sanitize((value) => value.trim())
        .validate((value) => value.length == 12 ? null : "Error");

    final refield1 = field("  hello, world  ");
    final refield2 = field("hello, world");

    expect(refield1.error, equals(null));
    expect(refield2.sanitizedValue == refield1.sanitizedValue, isTrue);
    expect(refield2.value == refield1.value, isFalse);
  });

  test("Nullability", () {
    Refield field(String? value) => refield(value)
        .validate((value) => value == null ? "Can't be null" : null)
        .as<String>()
        .validate((value) => value.length > 8 ? null : "Error");

    final refield1 = field(null);
    expect(refield1.error, equals("Can't be null"));
    expect(() => refield1.sanitizedValue, throwsA(isA<StateError>()));

    final refield2 = field("hllo");
    expect(refield2.error, equals("Error"));
    expect(refield2.sanitizedValue, equals("hllo"));

    final refield3 = field("hello, world");
    expect(refield3.error, equals(null));
    expect(refield3.sanitizedValue, equals("hello, world"));
  });

  test("Several sanitizers", () {
    Refield<String?, int> field(String? value) => refield(value)
        .validate((value) => value == null ? "Can't be null" : null)
        .as<String>()
        .validate((value) => value.length > 8 ? null : "Too short")
        .sanitize((value) => int.tryParse(value))
        .validate((value) => value != null ? null : "It's not an int")
        .as<int>();

    final refield1 = field(null);
    expect(refield1.error, equals("Can't be null"));
    expect(() => refield1.sanitizedValue, throwsA(isA<StateError>()));

    final refield2 = field("hell");
    expect(refield2.error, equals("Too short"));
    expect(() => refield2.sanitizedValue, throwsA(isA<StateError>()));

    final refield3 = field("hello, world");
    expect(refield3.error, equals("It's not an int"));
    expect(() => refield3.sanitizedValue, throwsA(isA<StateError>()));

    final refield4 = field("1234567");
    expect(refield4.error, equals("Too short"));
    expect(() => refield4.sanitizedValue, throwsA(isA<StateError>()));

    final refield5 = field("123456789");
    expect(refield5.error, equals(null));
    expect(refield5.sanitizedValue, equals(123456789));
    expect(refield5.value, equals("123456789"));
  });

  group("Pending", () {
    Refield field(String value) => refield(value)
        .sanitize((value) => value.replaceAll("@", ''))
        .validate((value) => value.length > 10 ? null : "Min 11 chars");

    test("Test", () {
      final usernameField = field("@myusername");
      expect(usernameField.pending().status, equals(FieldStatus.pending));

      expect(usernameField.withError("Usernames is already user").error,
          equals("Usernames is already user"));

      expect(usernameField.error, equals("Min 11 chars"));
      expect(usernameField.status, equals(FieldStatus.invalid));
    });

    test("Priority", () {
      final usernameField =
          refield("@my").pending().validate((value) => "Always error");
      expect(usernameField.status, equals(FieldStatus.pending));
      expect(usernameField.error, equals("Always error"));
      expect(Reform.isValid([usernameField]), false);
    });
  });
}
