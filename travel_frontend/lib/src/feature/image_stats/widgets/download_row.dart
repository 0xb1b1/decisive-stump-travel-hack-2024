import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../common/app_palette.dart';
import '../../../common/app_typography.dart';

class DownloadRow extends StatefulWidget {
  final VoidCallback onTap;

  const DownloadRow({
    required this.onTap,
    super.key,
  });

  @override
  State<DownloadRow> createState() => _DownloadRowState();
}

class _DownloadRowState extends State<DownloadRow> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: isChecked ? widget.onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 58,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isChecked ? AppPalette.yellow : AppPalette.grey,
            ),
            child: const Text(
              'Cкачать',
              style: AppTypography.boldText,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              AutoSizeText(
                'Обратите внимание на ограничения использования, установленные Лицензионным соглашением.',
                maxLines: 3,
                style: AppTypography.text.copyWith(
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    height: 14,
                    width: 14,
                    child: Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(
                          () {
                            isChecked = value!;
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    'Cоглашаюсь с условиями лицензионного соглашения',
                    style: AppTypography.text.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
