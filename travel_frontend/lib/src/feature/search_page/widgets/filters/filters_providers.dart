import 'package:riverpod/riverpod.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_view_model.dart';
import 'package:travel_frontend/src/feature/search_page_providers.dart';

final filtersViewModelProvider = Provider(
  (ref) => FiltersViewModel(
    ref.watch(imagePickerProvider),
  ),
);
