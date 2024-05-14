import 'package:flutter/material.dart';

class AtomImage extends CustomPainter {
  // jai passee trop de temps sur ca -(0_0)-
  int period;
  int atomNum;

  AtomImage(this.period, this.atomNum);
  final Paint _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    int dotsPerRing = (atomNum / period).floor();
    double ringSize = 20;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10,
        Paint()); // le cercle au milieu

    for (int i = 1; i <= period; i++) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), i * ringSize,
          _paint); //les anneaux

      for (int j = 0; j < dotsPerRing; j++) {
        double xPos = 0;
        double yPos = 0;

        switch (j) {
          // un switch case qui determine la position des electrons
          case 0:
            xPos = (i * ringSize * 0.7);
            yPos = (i * ringSize * 0.7);
            break;
          case 1:
            xPos = (i * -ringSize * 0.7);
            yPos = (i * ringSize * 0.7);
            break;
          case 2:
            xPos = (i * ringSize * 0.7);
            yPos = (i * -ringSize * 0.7);
            break;
          case 3:
            xPos = (i * -ringSize * 0.7);
            yPos = (i * -ringSize * 0.7);
            break;
          case 4:
            xPos = 0;
            yPos = (i * ringSize);
            break;
          case 5:
            xPos = (i * ringSize);
            yPos = 0;
            break;
          case 6:
            xPos = (i * -ringSize);
            yPos = 0;
            break;
          default:
            xPos = 0;
            yPos = (i * -ringSize);
            break;
        }

        canvas.drawCircle(Offset(size.width / 2 + xPos, size.height / 2 + yPos),
            5, Paint()); //les electrons
      }
    }
  }

  bool shouldRepaint(AtomImage oldImage) => true;
}
