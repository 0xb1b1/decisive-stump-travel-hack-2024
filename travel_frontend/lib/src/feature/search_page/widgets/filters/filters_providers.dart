import 'package:riverpod/riverpod.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_view_model.dart';

final filtersViewModelProvider = Provider(
  (ref) => FiltersViewModel(),
);
