import 'package:flutter/cupertino.dart';
import 'package:travel_frontend/core/view_model_hooks.dart';

abstract class BaseViewModel<ViewState> extends ChangeNotifier
    implements ViewModelHooks<ViewState> {
  late ViewState _state;

  ViewState get initState;

  @override
  ViewState get state => _state;

  @override
  @mustCallSuper
  void init() {
    _state = initState;
    notifyListeners();
  }

  void emit(ViewState newState) {
    _state = newState;
    notifyListeners();
  }
}
