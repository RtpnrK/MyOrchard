import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PinDetails extends StatelessWidget {
  final Color pinColor;
  final Offset pinOffset;
  final Position position;
  final VoidCallback remove; 

  const PinDetails({
    super.key,
    required this.pinColor,
    required this.pinOffset,
    required this.position,
    required this.remove,
  });

  @override
  Widget build(BuildContext context) {
    double lat = position.latitude;
    double long = position.longitude;
    TextStyle style = const TextStyle(fontSize: 15);

    return ExpansionTile(
      title: const Text("Pin"),
      leading: Icon(
        Icons.location_pin,
        color: pinColor,
        size: 30,
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              "Px: ${pinOffset.dx.toStringAsFixed(2)}",
              style: style,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              "Py: ${pinOffset.dy.toStringAsFixed(2)}",
              style: style,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              "Lat: $lat",
              style: style,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              "Long: $long",
              style: style,
            ),
          ),
        ),
        TextButton(
            onPressed: () => remove(),
            child: const Column(
              children: [Icon(Icons.delete), Text("Remove")],
            ))
      ],
    );
  }
}
