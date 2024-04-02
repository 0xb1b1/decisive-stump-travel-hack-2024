import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final navigationProvider = Provider(
  (ref) => NavigationService(
    navigatorKey: navigatorKey,
  ),
);
