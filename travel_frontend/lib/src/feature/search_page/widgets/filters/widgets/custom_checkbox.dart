import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final Color color;
  final VoidCallback onTap;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.color,
    required this.onTap,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          widget.onTap.call();
        });
      },
      child: Container(
        width: 12.0,
        height: 12.0,
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(
            color: AppPalette.darkGrey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: isChecked
            ? const Icon(
                Icons.check,
                size: 10.0,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
