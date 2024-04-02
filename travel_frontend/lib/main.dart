import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:travel_frontend/src/common/app_theme.dart';
import 'package:travel_frontend/src/navigation/navigation_providers.dart';

import 'package:travel_frontend/src/navigation/routes.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationProvider);

    return MaterialApp(
      navigatorKey: navigation.navigatorKey,
      title: 'Travel hack',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: Routes.onGenerateRoute,
      initialRoute: Routes.search,
    );
  }
}
