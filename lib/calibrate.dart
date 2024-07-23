import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  Color pin = Colors.black;
  bool pressedRed = false;
  bool pressedGreen = false;
  bool pressedBlue = false;

  String location = '';

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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.all(10),
              child: InteractiveViewer(
                child: GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      if (isPress) {
                        imgOffset = details.localPosition;
                        String dx = imgOffset.dx.toStringAsFixed(10);
                        String dy = imgOffset.dy.toStringAsFixed(10);
                        offsetShow = "Pixel Offset: $dx, $dy";

                        isPin = true;
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
                      if (isPress)
                        Positioned(
                            left: imgOffset.dx - 10,
                            top: imgOffset.dy - 20,
                            child:
                                Icon(Icons.location_pin, color: pin, size: 20))
                    ],
                  ),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                  visible: isPin,
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
                      child: Text("Cancel"))),
              Visibility(
                  visible: isPin,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: OutlinedButton(
                      onPressed: () {
                        _getCurrentLocation();
                      },
                      child: Text("Apply")))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !isPress,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        offsetShow = "Pin your location on the map";
                        isPress = true;
                        pin = Colors.red;
                        print(pin);
                      });
                    },
                    icon:
                        Icon(Icons.location_pin, size: 30, color: Colors.red)),
              ),
              Visibility(
                visible: !isPress,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        offsetShow = "Pin your location on the map";
                        isPress = true;
                        pin = Colors.green;
                      });
                    },
                    icon: Icon(
                      Icons.location_pin,
                      size: 30,
                      color: Colors.green,
                    )),
              ),
              Visibility(
                visible: !isPress,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        offsetShow = "Pin your location on the map";
                        isPress = true;
                        pin = Colors.blue;
                      });
                    },
                    icon: Icon(
                      Icons.location_pin,
                      size: 30,
                      color: Colors.blue,
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(offsetShow),
          Text(location)
        ],
      )),
    );
  }
}
