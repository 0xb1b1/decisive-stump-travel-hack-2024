import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/filters_list.dart';

part 'filters_container_state.freezed.dart';

part 'filters_container_state.g.dart';

@freezed
class FiltersContainerState with _$FiltersContainerState {
  const factory FiltersContainerState({
    required FiltersList filtersList,
    required String search,
  }) = _FiltersContainerState;

  factory FiltersContainerState.fromJson(Map<String, Object?> json) =>
      _$FiltersContainerStateFromJson(json);
}
