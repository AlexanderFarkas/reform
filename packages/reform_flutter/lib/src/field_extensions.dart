part of '../reform_flutter.dart';

extension FlutterRefieldX<T> on Field<T> {
  Widget builder({
    Key? key,
    ShowErrorPredicate? shouldShowError,
    required FieldWidgetBuilder<T> builder,
  }) =>
      RefieldBuilder<T>(
        key: key,
        field: this,
        shouldShowError: shouldShowError,
        builder: builder,
      );
}

extension FlutterTextRefieldX on Field<String> {
  Widget builder({
    Key? key,
    TextEditingController? controller,
    ShowErrorPredicate? shouldShowError,
    required ValueChanged<String> onChanged,
    required TextRefieldWidgetBuilder builder,
    bool syncController = true,
  }) =>
      TextRefieldBuilder(
        key: key,
        field: this,
        controller: controller,
        builder: builder,
        shouldShowError: shouldShowError,
        onChanged: onChanged,
        syncController: syncController,
      );
}
