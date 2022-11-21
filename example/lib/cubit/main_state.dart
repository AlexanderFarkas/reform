part of 'main_cubit.dart';

@freezed
class MainState with _$MainState {
  factory MainState({
    required String username,
    required String password,
    required String repeatPassword,
    required int age,
    required bool isSubmittedOnce,
  }) = _MainState;

  MainState._();

  late final usernameField = username.validate((value) {
    if (value.length < 8) {
      return "Min 8 chars";
    } else if (value.length > 16) {
      return "Max 16 chars";
    } else if (isAlphanumeric(value)) {
      return "Only numbers and letters";
    }
    return null;
  });

  late final passwordField = password.validate(
    (value) => value.length < 8 ? "At least 8 characters" : null,
  );

  late final repeatPasswordField = repeatPassword.validate(
    (value) => value != password ? "Passwords should match" : null,
  );

  late final ageField = age.validate(
    (value) => value < 18 ? "You should be 18 y.o" : null,
  );
}
