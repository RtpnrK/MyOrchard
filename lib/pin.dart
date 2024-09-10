import 'package:flutter/material.dart';

class Pin extends StatelessWidget {
  final Offset imgOffset;
  final Color pinColor;
  final double pinSize;
  const Pin({super.key, required this.imgOffset, required this.pinColor, required this.pinSize});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: imgOffset.dx - (pinSize/2),
        top: imgOffset.dy - pinSize,
        child: Icon(Icons.location_pin, color: pinColor, size: pinSize));
  }
}
