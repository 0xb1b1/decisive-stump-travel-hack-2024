import 'package:riverpod/riverpod.dart';
import 'package:travel_frontend/src/api/api_providers.dart';
import 'package:travel_frontend/src/domain/search_repository.dart';

final searchRepositoryProvider = Provider(
  (ref) => SearchRepository(
    api: ref.watch(appApiProvider),
  ),
);
