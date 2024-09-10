import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myorchard/pin.dart';
import 'package:myorchard/pinDetails.dart';

class Calibrate extends StatefulWidget {
  final File? image;
  const Calibrate({super.key, this.image});
  @override
  CalibrateState createState() => CalibrateState();
}

class CalibrateState extends State<Calibrate> {
  Offset imgOffset = const Offset(0, 0);
  Pin? oldPin;
  String offsetShow = "";
  String location = "";
  bool isPress = false;
  bool isPin = false;
  bool isUpdate = false;
  late Position currentPosition;
  double lat = 0;
  double long = 0;
  double pinSize = 50;
  Color pinColor = Colors.transparent;
  int index = 0;
  var currentPin = <int, Pin>{};
  var pinDetail = <int, PinDetails>{};

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

    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = currentPosition.latitude;
      long = currentPosition.longitude;
      String lx = lat.toStringAsFixed(10);
      String ly = long.toStringAsFixed(10);
      location = 'Lat: $lx, Long: $ly';
      updateDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      endDrawer: Drawer(
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Pin Details",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              ...pinDetail.values,
              SizedBox(height: 20),
              OutlinedButton(onPressed: (){}, child: Text('Calibrate'))
            ],
          ),
        )),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            width: 400,
            height: 350,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black), color: Colors.black),
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 2.0,
              constrained: false,
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    if (isPress) {
                      imgOffset = details.localPosition;
                      String dx = (imgOffset.dx).toStringAsFixed(10);
                      String dy = (imgOffset.dy).toStringAsFixed(10);
                      offsetShow = "Pixel Offset: $dx, $dy";
                      isPin = true;
                      if (!currentPin.containsKey(index)) {
                        oldPin = null;
                      }
                      currentPin[index] = Pin(
                        imgOffset: imgOffset,
                        pinColor: pinColor,
                        pinSize: pinSize,
                      );
                    }
                  });
                },
                child: Stack(
                  children: [
                    widget.image != null
                        ? Center(
                            child: Image.file(
                              widget.image!,
                            ),
                          )
                        : Image.asset("assets/images/map1.png",
                            fit: BoxFit.contain),
                    ...currentPin.values
                  ],
                ),
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
                          if (isUpdate) {
                            currentPin[index] = oldPin!;
                          } else if (oldPin == null) {
                            currentPin.remove(index);
                          }
                          isUpdate = false;
                          isPress = false;
                          isPin = false;
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
                              setState(() {
                                isPress = false;
                              });
                              _getCurrentLocation();
                            }
                          : null,
                      child: const Text("Apply"))),
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
                            if (currentPin.containsKey(index)) {
                              isUpdate = true;
                              oldPin = currentPin[index]!;
                            }
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
                            if (currentPin.containsKey(index)) {
                              isUpdate = true;
                              oldPin = currentPin[index]!;
                            }
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
                            if (currentPin.containsKey(index)) {
                              isUpdate = true;
                              oldPin = currentPin[index]!;
                            }
                          });
                        },
                  icon: const Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Colors.blue,
                  )),
                IconButton(
                  onPressed: isPress
                      ? null
                      : () {
                          setState(() {
                            offsetShow = "Pin your location on the map";
                            isPress = true;
                            pinColor = Colors.yellow;
                            index = 3;
                            if (currentPin.containsKey(index)) {
                              isUpdate = true;
                              oldPin = currentPin[index]!;
                            }
                          });
                        },
                  icon: const Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Colors.yellow,
                  )),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                  onPressed: () => updatePinSize(pinSize - 5),
                  icon: const Icon(Icons.remove_circle)),
              Text("$pinSize"),
              IconButton(
                  onPressed: () => updatePinSize(pinSize + 5),
                  icon: const Icon(Icons.add_circle))
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

  void updateDrawer() {
    pinDetail[index] = PinDetails(
        pinColor: pinColor,
        pinOffset: imgOffset,
        position: currentPosition,
        remove: () {
          print("test");
        });
  }

  void updatePinSize(double size) {
    setState(() {
      pinSize = size;
      currentPin.forEach((key, value) => currentPin[key] = Pin(
          imgOffset: value.imgOffset, pinColor: value.pinColor, pinSize: size));
    });
  }
}
