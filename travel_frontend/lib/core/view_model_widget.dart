import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_frontend/core/base_view_model.dart';

class ViewModelWidget<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final T model;
  final Widget? child;

  const ViewModelWidget({
    Key? key,
    required this.builder,
    required this.model,
    this.child,
  }) : super(key: key);

  @override
  State<ViewModelWidget<T>> createState() => _ViewModelWidgetState<T>();
}

class _ViewModelWidgetState<T extends BaseViewModel>
    extends State<ViewModelWidget<T>> {
  late T model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    model.init();
  }


  //TODO fix
  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
