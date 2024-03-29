part of '../reform_flutter.dart';

typedef ShowErrorPredicate<T> = bool Function(
  BuildContext context,
  RefieldBuilderState<T> fieldState,
);

class ReformScope extends InheritedWidget {
  final ShowErrorPredicate shouldShowError;
  const ReformScope({
    super.key,
    required this.shouldShowError,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant ReformScope oldWidget) {
    return shouldShowError != oldWidget.shouldShowError;
  }

  static ReformScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ReformScope>();
  }
}
