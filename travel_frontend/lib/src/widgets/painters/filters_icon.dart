import 'package:flutter/cupertino.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

class FiltersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path0 = Path()..fillType = PathFillType.evenOdd;
    path0.moveTo(16, 2);
    path0.cubicTo(14.8954, 2, 14, 2.89543, 14, 4);
    path0.cubicTo(14, 5.10457, 14.8954, 6, 16, 6);
    path0.cubicTo(17.1046, 6, 18, 5.10457, 18, 4);
    path0.cubicTo(18, 2.89543, 17.1046, 2, 16, 2);
    path0.close();
    path0.moveTo(12.126, 3);
    path0.cubicTo(12.5701, 1.27477, 14.1362, 0, 16, 0);
    path0.cubicTo(18.2091, 0, 20, 1.79086, 20, 4);
    path0.cubicTo(20, 6.20914, 18.2091, 8, 16, 8);
    path0.cubicTo(14.1362, 8, 12.5701, 6.72523, 12.126, 5);
    path0.lineTo(1, 5);
    path0.lineTo(0, 5);
    path0.lineTo(0.000000178814, 3);
    path0.lineTo(1, 3);
    path0.lineTo(12.126, 3);
    path0.close();
    path0.moveTo(4, 10);
    path0.cubicTo(2.89543, 10, 2, 10.8954, 2, 12);
    path0.cubicTo(2, 13.1046, 2.89543, 14, 4, 14);
    path0.cubicTo(5.10457, 14, 6, 13.1046, 6, 12);
    path0.cubicTo(6, 10.8954, 5.10457, 10, 4, 10);
    path0.close();
    path0.moveTo(0.000000119209, 12);
    path0.cubicTo(0.000000119209, 9.79086, 1.79086, 8, 4, 8);
    path0.cubicTo(5.86384, 8, 7.42994, 9.27477, 7.87398, 11);
    path0.lineTo(19, 11);
    path0.lineTo(20, 11);
    path0.lineTo(20, 13);
    path0.lineTo(19, 13);
    path0.lineTo(7.87398, 13);
    path0.cubicTo(7.42994, 14.7252, 5.86384, 16, 4, 16);
    path0.cubicTo(1.79086, 16, 0.000000119209, 14.2091, 0.000000119209, 12);
    path0.close();
    Paint paint0 = Paint();
    paint0.color = AppPalette.black;
    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant FiltersPainter oldDelegate) {
    return false;
  }
}
