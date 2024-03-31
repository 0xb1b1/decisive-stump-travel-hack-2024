import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class BaseViewModel<ViewState> extends ChangeNotifier {
  late ViewState _state;

  ViewState get initState;

  ViewState get state => _state;

  @override
  @mustCallSuper
  Future<void> dispose();

  @override
  @mustCallSuper
  void init() {
    _state = initState;
  }

  void emit(ViewState newState) {
    _state = newState;
    notifyListeners();
  }
}
