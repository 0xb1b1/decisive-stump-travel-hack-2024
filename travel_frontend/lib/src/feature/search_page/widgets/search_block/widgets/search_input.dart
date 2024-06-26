import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/app_typography.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/filters_view_model.dart';
import 'package:travel_frontend/src/feature/search_page/widgets/filters/models/search_type_state.dart';

class SearchInput extends StatefulWidget {
  final void Function(SearchTypeState) searchQuery;
  final FiltersViewModel filtersViewModel;
  final SearchTypeState searchState;

  const SearchInput({
    super.key,
    required this.searchQuery,
    required this.filtersViewModel,
    required this.searchState,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  InputBorder get border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.yellow, width: 2),
      );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.isNotEmpty;
      });
    });
    if (widget.searchState is SearchTypeStateTag) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: widget.filtersViewModel.state.when(
        tag: (__, tag) => Container(
          decoration: BoxDecoration(
            color: AppPalette.white,
            border: Border.all(
              color: AppPalette.yellow,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageContainerMode(
                title: 'Поиск по тегу: $tag',
                onCrossTap: () {
                  widget.filtersViewModel.onCrossTap();
                  widget.searchQuery(widget.filtersViewModel.state);
                },
              ),
              IconButton(
                color: AppPalette.yellow,
                icon: const Icon(
                  Icons.search,
                  color: AppPalette.black,
                ),
                onPressed: () =>
                    widget.searchQuery(widget.filtersViewModel.state),
              ),
            ],
          ),
        ),
        similar: (__, _) => Container(
          decoration: BoxDecoration(
            color: AppPalette.white,
            border: Border.all(
              color: AppPalette.yellow,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageContainerMode(
                title: 'Выбранное изображение',
                onCrossTap: () {
                  widget.filtersViewModel.onCrossTap();
                  widget.searchQuery(widget.filtersViewModel.state);
                },
              ),
              IconButton(
                color: AppPalette.yellow,
                icon: const Icon(
                  Icons.search,
                  color: AppPalette.black,
                ),
                onPressed: () =>
                    widget.searchQuery(widget.filtersViewModel.state),
              ),
            ],
          ),
        ),
        initial: (_, search) => TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Введите запрос',
            filled: true,
            fillColor: Colors.white,
            suffixIcon: _isTyping || widget.filtersViewModel.isFiltersChosen
                ? IconButton(
                    color: AppPalette.yellow,
                    icon: const Icon(
                      Icons.search,
                      color: AppPalette.black,
                    ),
                    onPressed: () {
                      widget.filtersViewModel
                          .changeSearchInitial(_controller.text);
                      widget.searchQuery(widget.filtersViewModel.state);
                    },
                  )
                : null,
            enabledBorder: border,
            focusedBorder: border,
          ),
        ),
      ),
    );
  }
}

class ImageContainerMode extends StatelessWidget {
  final String title;
  final VoidCallback onCrossTap;

  const ImageContainerMode({
    super.key,
    required this.title,
    required this.onCrossTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppPalette.grey,
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      margin: const EdgeInsets.all(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            size: 20,
            Icons.image,
            color: AppPalette.black,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTypography.boldText.copyWith(fontSize: 14),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onCrossTap,
            child: const Icon(
              size: 20,
              Icons.close,
              color: AppPalette.black,
            ),
          ),
        ],
      ),
    );
  }
}
