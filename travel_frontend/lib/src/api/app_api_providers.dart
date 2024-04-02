import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_frontend/src/api/api.dart';

final appApiProvider = Provider(
  (ref) => AppApi(
    ref.watch(_appDioProvider),
  ),
);

final _appDioProvider = Provider(
  (ref) => Dio(),
);
