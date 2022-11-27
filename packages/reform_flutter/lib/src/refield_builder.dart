part of '../reform_flutter.dart';

typedef FieldWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T value,
  String? errorText,
);

bool _defaultShouldShowError<T>(RefieldBuilderState<T> state) {
  return true;
}

class RefieldBuilder<T> extends StatefulWidget {
  final Field<T> field;
  final ShowErrorPredicate? shouldShowError;
  final FieldWidgetBuilder<T> builder;

  const RefieldBuilder({
    super.key,
    required this.field,
    required this.builder,
    this.shouldShowError,
  });

  @override
  State<RefieldBuilder<T>> createState() => RefieldBuilderState<T>();
}

class RefieldBuilderState<T> extends State<RefieldBuilder<T>> {
  bool hasFocus = false;
  bool wasEverUnfocused = false;
  bool wasChangedAfterFocus = false;
  bool wasChanged = false;

  @override
  void didUpdateWidget(covariant RefieldBuilder<T> oldWidget) {
    if (widget.field.value != oldWidget.field.value) {
      wasChanged = true;
      if (hasFocus) {
        wasChangedAfterFocus = true;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onFocusChange: (hasFocus) {
        setState(() {
          this.hasFocus = hasFocus;
          if (!hasFocus) {
            wasEverUnfocused = true;
            wasChangedAfterFocus = false;
          }
        });
      },
      child: Builder(
        builder: (context) {
          final field = widget.field;
          final ShowErrorPredicate<T> shouldShowErrorFn = widget.shouldShowError ??
              ReformScope.of(context)?.shouldShowError ??
              _defaultShouldShowError;

          return widget.builder(
            context,
            field.value,
            shouldShowErrorFn(this) ? field.displayError : null,
          );
        },
      ),
    );
  }
}
