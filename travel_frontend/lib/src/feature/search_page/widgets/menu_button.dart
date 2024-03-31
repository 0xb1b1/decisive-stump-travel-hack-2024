import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButton extends StatelessWidget {
  final bool isPressed;
  final String text;
  final String path;

  const MenuButton({
    super.key,
    required this.isPressed,
    required this.text,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isPressed ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            path,
            width: 24,
            height: 24,
            color: isPressed ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isPressed ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
