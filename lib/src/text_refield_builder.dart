part of '../reform.dart';

typedef TextRefieldWidgetBuilder = Widget Function(
  BuildContext context,
  TextEditingController controller,
  String? errorText,
);

class TextRefieldBuilder extends StatefulWidget {
  final Refield<String> field;
  final ShowErrorPredicate? shouldShowError;
  final TextEditingController? controller;
  final TextRefieldWidgetBuilder builder;

  const TextRefieldBuilder({
    super.key,
    this.controller,
    required this.field,
    required this.builder,
    this.shouldShowError,
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
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TextRefieldBuilder oldWidget) {
    final value = widget.field.value;
    if (value != controller.text) {
      setState(() => controller.text = value);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefieldBuilder(
      field: widget.field,
      shouldShowError: widget.shouldShowError,
      builder: (context, value, error) =>
          widget.builder(context, controller, error),
    );
  }
}
