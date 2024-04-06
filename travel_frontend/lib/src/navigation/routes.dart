import 'package:flutter/material.dart';
import 'package:travel_frontend/src/feature/search_page/search_page.dart';

import '../feature/image_stats/image_stats_page.dart';

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
          builder: (_) => const ImageStats(),
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
  static const filename = 'filename';
  static const tag = 'tag';
  static const uploadedFile = 'uploadedFile';
}

T? componentArg0f<T>(BuildContext context, String key) =>
    _componentArgOfRoute<T>(ModalRoute.of(context), key);

T? _componentArgOfRoute<T>(Route? route, String key) {
  final args = route?.settings.arguments as Map<String, dynamic>?;
  return args?[key] as T?;
}
