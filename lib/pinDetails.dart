import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PinDetails extends StatelessWidget {
  final Color pinColor;
  final Offset pinOffset;
  final Position position;
  final VoidCallback edit;
  final VoidCallback remove; 

  const PinDetails({
    super.key,
    required this.pinColor,
    required this.pinOffset,
    required this.position,
    required this.edit,
    required this.remove,
  });

  @override
  Widget build(BuildContext context) {
    double lat = position.latitude;
    double long = position.longitude;
    TextStyle style = TextStyle(fontSize: 15);

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
              "Px: ${pinOffset.dx}",
              style: style,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              "Py: ${pinOffset.dy}",
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: () => edit,
                child: const Column(
                  children: [Icon(Icons.edit), Text("Edit")],
                )),
            TextButton(
                onPressed: () => remove,
                child: const Column(
                  children: [Icon(Icons.delete), Text("Remove")],
                )),
          ],
        )
      ],
    );
  }
}
