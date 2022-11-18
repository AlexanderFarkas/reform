import 'package:bloc/bloc.dart';
import 'package:reform/reform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:validators/validators.dart';

part 'main_state.dart';
part 'main_cubit.freezed.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit()
      : super(
          MainState(
            username: "",
            password: "",
            repeatPassword: "",
            age: 0,
            isSubmittedOnce: false,
          ),
        );

  void onUsernameChanged(String value) {
    emit(state.copyWith(username: value));
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void onRepeatPasswordChanged(String value) {
    emit(state.copyWith(repeatPassword: value));
  }

  void onAgeIncrement() => _onAgeChanged(state.age + 1);
  void onAgeDecrement() => _onAgeChanged(state.age - 1);

  void _onAgeChanged(int value) {
    emit(state.copyWith(age: value));
  }

  void submit() {
    emit(state.copyWith(isSubmittedOnce: true));
    final isFormValid = Reform.validate([
      state.usernameField,
      state.passwordField,
      state.repeatPasswordField,
      state.ageField,
    ]);

    if (isFormValid) {
      print("Success");
    } else {
      print("Failure");
    }
  }
}
