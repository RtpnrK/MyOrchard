import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:myorchard/model/pinModel.dart';
import 'package:myorchard/optimize.dart';
import 'package:myorchard/pin.dart';
import 'package:myorchard/pinDetails.dart';
import 'package:myorchard/pinsDB.dart';
import 'package:sqflite/utils/utils.dart';

class Calibrate extends StatefulWidget {
  final File? image;
  const Calibrate({super.key, this.image});
  @override
  CalibrateState createState() => CalibrateState();
}

class CalibrateState extends State<Calibrate> {
  Offset imgOffset = const Offset(0, 0);
  Offset currentOffset = const Offset(0, 0);
  Pin? oldPin;
  String message = "Please add pin at least 3 points to start calibrate.";
  bool isPress = false;
  bool isPin = false;
  bool isUpdate = false;
  double lat = 0;
  double long = 0;
  double pinSize = 50;
  Color pinColor = Colors.transparent;
  Color pickerColor = Colors.transparent;
  int index = 0;
  int pinCount = 0;
  var currentPin = <int, Pin>{};
  var pinDetail = <int, PinDetails>{};
  late Position currentPosition;
  late double newPinSize;
  late Optimize opt;
  late List pins = [];

  @override
  void initState() {
    DatabaseHelper().getPins();
    loadData();
    DatabaseHelper().fetchPins();
    super.initState();
  }

  Future<void> loadData() async {
    List<PinM> pins = await DatabaseHelper().getPins();
    print("Data Loaded!");
    setState(() {
       for (var pin in pins) {
        pinDetail[pin.id!] = PinDetails(
        pinColor: colorFromHex(pin.color)!,
        pinOffset: Offset(pin.offsetX, pin.offsetY),
        lat: pin.latitude,
        long: pin.longitude,
        remove: () {
          setState(() {
            currentPin.remove(pin.id);
            pinDetail.remove(pin.id);
            pinCount--;
          });
        });
        currentPin[pin.id!] = Pin(
          imgOffset: Offset(pin.offsetX, pin.offsetY),
          pinColor: colorFromHex(pin.color)!,
          pinSize: pinSize);
    }
    });
  
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        message = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          message = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        message =
            'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
        
    setState(() {
      lat = currentPosition.latitude;
      long = currentPosition.longitude;
    });
  }

  Future<void> _loadingState() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    await _getCurrentLocation();
    if (mounted) {
      Navigator.of(context).pop();
    }
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
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: pinDetail.length >= 3
                    ? () async {
                        List<List<double>> l1 = [[], []];
                        List<List<double>> l2 = [[], []];
                        DatabaseHelper().deleteAllPins();
                        pinDetail.forEach((i, e) {
                          l1[0].add(e.lat);
                          l1[1].add(e.long);
                          l2[0].add(e.pinOffset.dx);
                          l2[1].add(e.pinOffset.dy);
                          DatabaseHelper().insertPin(PinM(
                              latitude: e.lat,
                              longitude: e.long,
                              offsetX: e.pinOffset.dx,
                              offsetY: e.pinOffset.dy,
                              color: e.pinColor.value.toRadixString(16)));
                        });
                        var GP = Matrix.fromList(l1, dtype: DType.float64);
                        var SP = Matrix.fromList(l2, dtype: DType.float64);
                        opt = Optimize(GP, SP);
                        opt.solve();
                        await _loadingState();
                        var current_gp = Matrix.fromList([
                          [lat],
                          [long]
                        ], dtype: DType.float64);
                        var current_sp = opt.toSP(current_gp);
                        currentOffset =
                            Offset(current_sp[0][0], current_sp[1][0]);
                        log(current_sp.toString());
                        log(current_gp.toString());

                        print("Pins");
                        DatabaseHelper().fetchPins();
                      }
                    : null,
                label: const Text('Calibrate'),
                icon: const Icon(Icons.compass_calibration),
              )
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
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(64, 64, 64, 1), blurRadius: 10)
              ],
            ),
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 2.0,
              constrained: false,
              child: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    if (isPress) {
                      imgOffset = details.localPosition;
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
                    ...currentPin.values,
                    Positioned(
                      left: currentOffset.dx - (pinSize / 2),
                      top: currentOffset.dy - pinSize,
                      child: Icon(Icons.man, size: pinSize),
                    )
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
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPin.remove(index);
                          isPress = false;
                          isPin = false;
                          message = "";
                        });
                      },
                      child: const Text("Cancel"))),
              Visibility(
                  visible: isPress,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: ElevatedButton(
                      onPressed: isPin
                          ? () async {
                              setState(() {
                                isPress = false;
                              });
                              await _loadingState();
                              updateDrawer();
                              pinCount++;
                              message = "Your location is saved at $imgOffset.";
                            }
                          : null,
                      child: const Text("Apply"))),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: pinCount < 5
                      ? () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Select Pin Color"),
                                  content: BlockPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: colorChange),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            pinColor = pickerColor;
                                          });
                                          message =
                                              "Mark your location on a map.";
                                          index = pinCount;
                                          isPress = true;
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK"))
                                  ],
                                );
                              });
                        }
                      : null,
                  label: const Text("Add Pin"),
                  icon: const Icon(
                    Icons.location_pin,
                    size: 30,
                  )),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  newPinSize = pinSize;
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: const Text('Pin Settings'),
                            content: Row(
                              children: [
                                const Text(
                                  'Pin Size',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        newPinSize -= 5;
                                      });
                                    },
                                    icon: const Icon(Icons.remove_circle)),
                                Text('$newPinSize'),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        newPinSize += 5;
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle)),
                              ],
                            ),
                            actions: [
                              OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  child: const Text('Cancel')),
                              OutlinedButton(
                                  onPressed: () {
                                    pinSize = newPinSize;
                                    updatePinSize(newPinSize);
                                    Navigator.pop(context, 'Apply');
                                  },
                                  child: const Text('Apply'))
                            ],
                          );
                        });
                      });
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text(message),
        ],
      )),
    );
  }

  void updateDrawer() {
    int thisPin = index;
    pinDetail[index] = PinDetails(
        pinColor: pinColor,
        pinOffset: imgOffset,
        lat: currentPosition.latitude,
        long: currentPosition.longitude,
        remove: () {
          setState(() {
            currentPin.remove(thisPin);
            pinDetail.remove(thisPin);
            pinCount--;
          });
        });
  }

  void updatePinSize(double size) {
    setState(() {
      pinSize = size;
      currentPin.forEach((key, value) => currentPin[key] = Pin(
          imgOffset: value.imgOffset, pinColor: value.pinColor, pinSize: size));
    });
  }

  void colorChange(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  Future<void> updateGPS() async {
    await _getCurrentLocation();
    var current_gp = Matrix.fromList([
      [lat],
      [long]
    ], dtype: DType.float64);
    var current_sp = opt.toSP(current_gp);
    log(current_sp.toString());
    log(current_gp.toString());
    setState(() {
      currentOffset = Offset(current_sp[0][0], current_sp[1][0]);
    });
  }
}
