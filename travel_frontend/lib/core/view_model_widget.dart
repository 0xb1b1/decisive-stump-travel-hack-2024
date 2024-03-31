import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModelWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final T model;
  final Widget? child;
  final Function(T) onModelReady;

  const ViewModelWidget({
    Key? key,
    required this.builder,
    required this.model,
    this.child,
    required this.onModelReady,
  }) : super(key: key);

  @override
  State<ViewModelWidget<T>> createState() => _ViewModelWidgetState<T>();
}

class _ViewModelWidgetState<T extends ChangeNotifier> extends State<ViewModelWidget<T>> {
  late T model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    widget.onModelReady(model);
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
