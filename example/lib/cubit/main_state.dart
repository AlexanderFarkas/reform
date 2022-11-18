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

  late final usernameField = username
      .validate((value) => isLength(value, 8), "Min 8 chars")
      .then((value) => isLength(value, 0, 16), "Max 16 chars")
      .then(isAlphanumeric, "Username should contain only numbers and letters");

  late final passwordField = password.validate(
    (value) => isLength(value, 8),
    "At least 8 characters",
  );

  late final repeatPasswordField = repeatPassword.validate(
    (value) => value == password,
    "Passwords should match",
  );

  late final ageField = age.validate(
    (value) => value >= 18,
    "You should be 18 yrs old",
  );
}
