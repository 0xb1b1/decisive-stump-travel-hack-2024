import 'package:riverpod/riverpod.dart';
import 'package:travel_frontend/src/api/api_providers.dart';
import 'package:travel_frontend/src/domain/image_repository.dart';

final imageRepositoryProvider = Provider(
  (ref) => ImageRepository(
    api: ref.watch(appApiProvider),
  ),
);
