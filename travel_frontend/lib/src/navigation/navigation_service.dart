import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey;

  NavigationService({
    required GlobalKey<NavigatorState> navigatorKey,
  }) : _navigatorKey = navigatorKey;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return _navigator.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void pop() {
    return _navigator.pop();
  }
}
