part of '../reform.dart';

typedef TextRefieldWidgetBuilder = Widget Function(
  BuildContext context,
  TextEditingController controller,
  String? errorText,
);

class TextRefieldBuilder extends StatefulWidget {
  final Refield<String> field;
  final ValueChanged<String> onChanged;
  final ShowErrorPredicate? shouldShowError;
  final TextEditingController? controller;
  final TextRefieldWidgetBuilder builder;

  const TextRefieldBuilder({
    super.key,
    this.controller,
    required this.field,
    required this.onChanged,
    this.shouldShowError,
    required this.builder,
  });

  @override
  State<TextRefieldBuilder> createState() => _TextRefieldBuilderState();
}

class _TextRefieldBuilderState extends State<TextRefieldBuilder> {
  late final controller = widget.controller ?? TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.field.value;
    controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    controller.removeListener(_controllerListener);
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  void _controllerListener() {
    final controllerText = controller.text;
    if (controllerText != widget.field.value) {
      widget.onChanged(controllerText);
    }
  }

  @override
  void didUpdateWidget(covariant TextRefieldBuilder oldWidget) {
    final value = widget.field.value;
    if (value != controller.text) {
      controller.text = value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefieldBuilder(
      field: widget.field,
      shouldShowError: widget.shouldShowError,
      builder: (context, value, error) => widget.builder(context, controller, error),
    );
  }
}
