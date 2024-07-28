import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myorchard/pin.dart';

class Calibrate extends StatefulWidget {
  final File? image;
  const Calibrate({super.key, this.image});
  @override
  CalibrateState createState() => CalibrateState();
}

class CalibrateState extends State<Calibrate> {
  Offset imgOffset = const Offset(0, 0);
  final Offset initOffset = const Offset(0, 0);
  String offsetShow = "";
  String location = '';
  bool isPress = false;
  bool isPin = false;
  double lat = 0;
  double long = 0;
  final double pinSize = 100;
  Color pinColor = Colors.transparent;
  int index = 0;
  var currentPin = <int, Pin>{};
  var pinDetail = <int, ExpansionTile>{};
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    // ตั้งค่า scale เริ่มต้น
    _transformationController.value = Matrix4.identity()
      ..scale(0.3); // กำหนดค่า scale
  }

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
      desiredAccuracy: LocationAccuracy.high
    );
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      String lx = lat.toStringAsFixed(10);
      String ly = long.toStringAsFixed(10);
      location = 'Lat: $lx, Long: $ly';
      updateDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      endDrawer: Drawer(
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [Text("Pin Details"), ...pinDetail.values],
          ),
        )),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            width: 400,
            height: 350,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black), color: Colors.black),
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.1,
              maxScale: 0.8,
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
                              setState(() {
                                isPress = false;
                              });
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

  void updateDrawer() {
       pinDetail[index] = ExpansionTile(
      title: Text("Pin"),
      leading: Icon(
        Icons.location_pin,
        color: pinColor,
        size: 30,
      ),
      children: [
        ListTile(
          title: Text("Px: ${imgOffset.dx}"),
        ),
        ListTile(
          title: Text("Py: ${imgOffset.dy}"),
        ),
        ListTile(
          title: Text("Lat: $lat"),
        ),
        ListTile(
          title: Text("Long: $long"),
        ),
      ],
    );
  }
}
