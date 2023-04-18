part of '../reform_flutter.dart';

typedef TextRefieldWidgetBuilder = Widget Function(
  BuildContext context,
  TextEditingController controller,
  String? errorText,
);

class TextRefieldBuilder extends StatefulWidget {
  final Field<String> field;
  final ValueChanged<String> onChanged;
  final ShowErrorPredicate? shouldShowError;
  final TextEditingController? controller;
  final TextRefieldWidgetBuilder builder;

  /// Whether to propagate [field.value] changes to underlying controller
  /// `true` by default
  final bool syncController;

  const TextRefieldBuilder({
    super.key,
    this.controller,
    required this.field,
    required this.onChanged,
    this.shouldShowError,
    required this.builder,
    this.syncController = true,
  });

  @override
  State<TextRefieldBuilder> createState() => _TextRefieldBuilderState();
}

class _TextRefieldBuilderState extends State<TextRefieldBuilder> {
  late final controller = widget.controller ?? TextEditingController();
  late final bool isExternalController;

  @override
  void initState() {
    super.initState();
    isExternalController = widget.controller != null;

    if (!isExternalController) {
      controller.text = widget.field.value;
    }

    controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    controller.removeListener(_controllerListener);
    if (!isExternalController) {
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
    if (widget.syncController && value != controller.text) {
      controller.text = value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefieldBuilder(
      field: widget.field,
      shouldShowError: widget.shouldShowError,
      builder: (context, error) => widget.builder(context, controller, error),
    );
  }
}
