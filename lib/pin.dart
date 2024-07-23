import 'package:flutter/material.dart';

class Pin extends StatelessWidget {
  Offset imgOffset;
  Color pinColor;
  double pinSize;
  Pin({super.key, required this.imgOffset, required this.pinColor, required this.pinSize});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: imgOffset.dx - (pinSize/2),
        top: imgOffset.dy - pinSize,
        child: Icon(Icons.location_pin, color: pinColor, size: pinSize));
  }
}
