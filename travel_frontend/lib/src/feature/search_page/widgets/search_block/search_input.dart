import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/assets_provider.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Введите запрос',
        filled: true,
        fillColor: Colors.white,
        suffixIcon: AssetsProvider.search,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.yellow, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.yellow, width: 2),
        ),
      ),
    );
  }
}
