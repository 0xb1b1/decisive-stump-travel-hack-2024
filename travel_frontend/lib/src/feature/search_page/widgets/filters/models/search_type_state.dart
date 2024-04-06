import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'filters_list.dart';

part 'search_type_state.freezed.dart';

@freezed
class SearchTypeState with _$SearchTypeState {
  const factory SearchTypeState.initial({
    required FiltersList filtersList,
    required String search,
  }) = SearchTypeStateInitial;

  const factory SearchTypeState.tag({
    required FiltersList filtersList,
    required String tag,
  }) = SearchTypeStateTag;

  const factory SearchTypeState.similar({
    required FiltersList filtersList,
    required String filename,
  }) = SearchTypeStateSimilar;
}

enum SearchTypeMode {
  initial,
  tag,
  similar,
}
