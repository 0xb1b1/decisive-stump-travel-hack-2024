import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:travel_frontend/src/api/api.dart';

final _dioProvider = Provider((ref) => Dio());

final appApiProvider = Provider(
  (ref) => AppApi(
    ref.watch(_dioProvider),
  ),
);
