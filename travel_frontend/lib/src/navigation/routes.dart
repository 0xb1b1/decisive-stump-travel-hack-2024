import 'package:flutter/material.dart';
import 'package:travel_frontend/src/feature/search_page/search_page.dart';

import '../feature/image_stats/image_stats.dart';

abstract class Routes {
  static const search = 'search';
  static const imageStats = 'imageStats';
  static const imageSimilar = 'imageSimilar';

  static final table = <String, Route Function(RouteSettings)>{
    Routes.search: (settings) => MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SearchPage(),
        ),
    Routes.imageStats: (settings) => MaterialPageRoute<void>(
          builder: (_) => ImageStats(filename: settings.arguments as String),
          settings: settings,
        ),
  };

  static Route onGenerateRoute(RouteSettings settings) {
    final routeBuilder = Routes.table[settings.name];

    if (routeBuilder != null) {
      return routeBuilder(settings);
    }

    throw Exception('Wrong route ${settings.name}');
  }
}

abstract class RoutesArgs {
  static const imageUuid = 'imageUuid';
}

T? componentArg0f<T>(BuildContext context, String key) =>
    _componentArgOfRoute<T>(ModalRoute.of(context), key);

T? _componentArgOfRoute<T>(Route? route, String key) {
  final args = route?.settings.arguments as Map<String, dynamic>?;
  return args?[key] as T?;
}
