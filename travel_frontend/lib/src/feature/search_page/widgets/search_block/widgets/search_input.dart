import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/assets_provider.dart';

class SearchInput extends StatefulWidget {
  final void Function(String) onSearchTap;
  final bool isFiltersChosen;

  const SearchInput({
    super.key,
    required this.onSearchTap,
    required this.isFiltersChosen,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.isNotEmpty;
      });
    });
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
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Введите запрос',
          filled: true,
          fillColor: Colors.white,
          suffixIcon: _isTyping || widget.isFiltersChosen
              ? IconButton(
                  color: AppPalette.yellow,
                  icon: const Icon(
                    Icons.search,
                    color: AppPalette.black,
                  ),
                  onPressed: () => widget.onSearchTap(_controller.text),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppPalette.yellow, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppPalette.yellow, width: 2),
          ),
        ),
      ),
    );
  }
}
