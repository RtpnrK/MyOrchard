import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myorchard/pin.dart';

class Calibrate extends StatefulWidget {
  File? image;
  Calibrate({super.key, this.image});
  @override
  CalibrateState createState() => CalibrateState();
}

class CalibrateState extends State<Calibrate> {
  Offset imgOffset = const Offset(0, 0);
  final Offset initOffset = const Offset(0, 0);
  String offsetShow = "";
  bool isPress = false;
  bool isPin = false;
  String location = '';
  double lat = 0;
  double long = 0;
  final double pinSize = 20;
  Color pinColor = Colors.transparent;
  int index = 0;
  var currentPin = <int, Pin>{};

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        location = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location =
            'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      String lat = position.latitude.toStringAsFixed(10);
      String long = position.longitude.toStringAsFixed(10);
      location = 'Lat: $lat, Long: $long';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calibrate"),
        centerTitle: true,
      ),
      endDrawer: Drawer(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InteractiveViewer(
            child: GestureDetector(
              onTapDown: (details) {
                setState(() {
                  if (isPress) {
                    imgOffset = details.localPosition;
                    String dx = imgOffset.dx.toStringAsFixed(10);
                    String dy = imgOffset.dy.toStringAsFixed(10);
                    offsetShow = "Pixel Offset: $dx, $dy";
                    isPin = true;
                    if (currentPin.containsKey(index)) {
                      currentPin.update(
                          index,
                          (value) => Pin(
                              imgOffset: imgOffset,
                              pinColor: pinColor,
                              pinSize: pinSize));
                      return;
                    }
                    currentPin[index] = Pin(
                        imgOffset: imgOffset,
                        pinColor: pinColor,
                        pinSize: pinSize);
                  }
                });
              },
              child: Stack(
                children: [
                  widget.image != null
                      ? Image.file(
                          widget.image!,
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                        )
                      : Image.asset("assets/images/map1.png",
                          fit: BoxFit.contain),
                  ...currentPin.values
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                  visible: isPress,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isPress = false;
                          isPin = false;
                          imgOffset = initOffset;
                          offsetShow = "";
                          location = "";
                        });
                      },
                      child: const Text("Cancel"))),
              Visibility(
                  visible: isPress,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: OutlinedButton(
                      onPressed: isPin
                          ? () {
                              _getCurrentLocation();
                            }
                          : null,
                      child: const Text("Apply")))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: isPress
                      ? null
                      : () {
                          setState(() {
                            offsetShow = "Pin your location on the map";
                            isPress = true;
                            pinColor = Colors.red;
                            index = 0;
                          });
                        },
                  icon: const Icon(Icons.location_pin,
                      size: 30, color: Colors.red)),
              IconButton(
                  onPressed: isPress
                      ? null
                      : () {
                          setState(() {
                            offsetShow = "Pin your location on the map";
                            isPress = true;
                            pinColor = Colors.green;
                            index = 1;
                          });
                        },
                  icon: const Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: isPress
                      ? null
                      : () {
                          setState(() {
                            offsetShow = "Pin your location on the map";
                            isPress = true;
                            pinColor = Colors.blue;
                            index = 2;
                          });
                        },
                  icon: const Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Colors.blue,
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(offsetShow),
          Text(location)
        ],
      )),
    );
  }
}
