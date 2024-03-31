import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({super.key});

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: Checkbox(
        activeColor: AppPalette.yellow,
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),
    );
  }
}
