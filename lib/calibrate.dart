import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:myorchard/optimize.dart';

class Calibrate extends StatefulWidget {
  final File image;
  final double? scale;
  const Calibrate({super.key, required this.image, this.scale});

  @override
  State<Calibrate> createState() => _CalibrateState();
}

class _CalibrateState extends State<Calibrate> {
  TransformationController viewTranformationController =
      TransformationController();
  double pinSize = 30;
  double totalDistance = 0;
  bool advanceMode = false;
  bool isPin = false;
  Color pinColor = Colors.transparent;
  Color pickerColor = Colors.transparent;
  List<Pin> pinList = [];
  int index = 0;
  String message = '';
  Offset myPosition = Offset.zero;
  late double lat;
  late double long;
  Optimize? opt;
  late Position position;
  StreamSubscription<Position>? positionStreamSubscription;

  @override
  void initState() {
    viewTranformationController.value = Matrix4.identity() * widget.scale;
    _checkPermission();
    super.initState();
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(top: 12.h, left: 10.w),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 40.h,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'ปรับเทียบ',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: TextButton.icon(
              onPressed: () {},
              label: Text('บันทึก'),
              icon: Icon(
                Icons.save,
                size: 30.sp,
              ),
              iconAlignment: IconAlignment.end,
            ),
          )
        ],
        toolbarHeight: 100.h,
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        width: double.infinity,
        color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton.filled(
              style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        title: const Text("Select Pin Color"),
                        content: BlockPicker(
                            pickerColor: pickerColor,
                            onColorChanged: (color) {
                              setState(() {
                                pickerColor = color;
                              });
                            }),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("ยกเลิก")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  pinColor = pickerColor;
                                  isPin = true;
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text("ตกลง"))
                        ],
                      );
                    });
              },
              icon: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 20.sp,
                  ),
                  Icon(
                    Icons.location_pin,
                    size: 30.sp,
                  )
                ],
              )),
          SizedBox(
            height: 50.h,
            width: 150.w,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              onPressed: pinList.length >= 3
                  ? () {
                      double errAvg = 0;
                      pinList.forEach((Pin p) {
                        errAvg += p.position.accuracy;
                      });
                      errAvg /= pinList.length;    
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Calibrate',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                contentPadding: EdgeInsets.all(20.sp),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  height: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'จำนวน pin: ${pinList.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      ),
                                      Text(
                                        'ระยะทางทั้งหมด: ${totalDistance.toStringAsFixed(2)} เมตร',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      ),
                                      Text(
                                        'Error เฉลี่ย: ${errAvg.toStringAsFixed(2)} เมตร',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      )
                                    ],
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _calibrate();
                                      _startLocationUpdates();
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: Text('Start Calibrate'),
                                  ),
                                ],
                              ));
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        'กรุณาปักหมุดอย่างน้อย 3 ตำแหน่ง',
                        style: TextStyle(fontSize: 20.sp),
                      )));
                    },
              label: Text('Calibrate', style: TextStyle(
                fontSize: 16.sp
              ),),
              icon: ImageIcon(
                AssetImage('assets/icons/calibrate.png'),
                size: 25.sp,
              ),
            ),
          ),
          IconButton.filled(
              style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                if (isPin) {
                  pinCancel();
                }
                showModalBottomSheet(
                    showDragHandle: true,
                    context: context,
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => StatefulBuilder(
                            builder: (context, setBottomSheetState) {
                          return DraggableScrollableSheet(
                              expand: false,
                              builder: (context, scrollController) =>
                                  SingleChildScrollView(
                                    controller: scrollController,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30.w),
                                              topRight: Radius.circular(30.w))),
                                      child: Column(
                                        children: List.generate(
                                            pinList.length,
                                            (idx) => Column(
                                                  children: [
                                                    ListTile(
                                                      trailing: IconButton(
                                                          onPressed: () {
                                                            setBottomSheetState(
                                                                () {
                                                              setState(() {
                                                                pinList
                                                                    .removeAt(
                                                                        idx);
                                                                index--;
                                                              });
                                                            });
                                                          },
                                                          icon: Icon(
                                                            Icons.delete,
                                                            size: 40.sp,
                                                          )),
                                                      leading: Icon(
                                                        Icons.location_pin,
                                                        color: pinList[idx]
                                                            .pinColor,
                                                        size: 40.sp,
                                                      ),
                                                      title: Text(
                                                          'Pin No.${idx + 1}',
                                                          style: Theme.of(context).textTheme.bodyMedium,),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Pixel Offset: ${pinList[idx].pinOffset.toString()}',
                                                              style: Theme.of(context).textTheme.bodySmall,),
                                                          Text(
                                                              'Latitude: ${pinList[idx].position.latitude}',
                                                              style: Theme.of(context).textTheme.bodySmall),
                                                          Text(
                                                              'Longtitude: ${pinList[idx].position.longitude}',
                                                              style: Theme.of(context).textTheme.bodySmall),
                                                          Text(
                                                            'Error: ${pinList[idx].position.accuracy.toStringAsFixed(2)} เมตร',
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 2,
                                                      indent: 20.w,
                                                      endIndent: 20.w,
                                                    )
                                                  ],
                                                )),
                                      ),
                                    ),
                                  ));
                        }));
              },
              icon: Icon(
                Icons.list,
                size: 30.sp,
              )),
          IconButton.filled(
              style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                double size = pinSize;
                bool mode = advanceMode;
                showDialog(
                    context: context,
                    builder: (context) =>
                        StatefulBuilder(builder: (context, setDialogState) {
                          return AlertDialog(
                            title: Text(
                              'ตั้งค่า',
                              textAlign: TextAlign.center,
                            ),
                            content: SizedBox(
                              height: 200.h,
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('ขนาด Pin'),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setDialogState(() {
                                                  size -= 5;
                                                });
                                              },
                                              icon: Icon(Icons.remove)),
                                          Text('$size'),
                                          IconButton(
                                              onPressed: () {
                                                setDialogState(() {
                                                  size += 5;
                                                });
                                              },
                                              icon: Icon(Icons.add)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('ขั้นสูง (ใช้เวลานานขึ้น)'),
                                      Switch(
                                          value: mode,
                                          onChanged: (value) {
                                            setDialogState(() {
                                              mode = value;
                                            });
                                          })
                                    ],
                                  )
                                ],
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.spaceAround,
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ยกเลิก')),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      pinSize = size;
                                      advanceMode = mode;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ตกลง'))
                            ],
                          );
                        }));
              },
              icon: Icon(
                Icons.settings,
                size: 30.sp,
              )),
        ]),
      ),
      body: Center(
          child: Stack(
        children: [
          InteractiveViewer(
              minScale: 0.2,
              transformationController: viewTranformationController,
              constrained: false,
              child: GestureDetector(
                  onTapDown: isPin
                      ? (details) {
                          setState(() {
                            print(details.localPosition);
                            Offset pinPosition = details.localPosition;
                            if (pinList.length == index) {
                              // Don't have any value at pinList[index].
                              pinList.add(Pin(pinPosition, pinColor));
                            } else {
                              pinList[index].pinOffset =
                                  pinPosition; // Edit value in pinList[index].
                            }
                            print(pinList.length);
                            print(index);
                          });
                        }
                      : null,
                  child: Stack(
                    children: [
                      Image(image: FileImage(widget.image)),
                      ...List.generate(
                          pinList.length,
                          (idx) => Positioned(
                              top: (pinList[idx].pinOffset.dy) - pinSize,
                              left: (pinList[idx].pinOffset.dx) - (pinSize / 2),
                              child: Icon(
                                Icons.location_pin,
                                color: pinList[idx].pinColor,
                                size: pinSize,
                              ))),
                      Positioned(
                          left: myPosition.dx - (pinSize / 2),
                          top: myPosition.dy - pinSize,
                          child: Icon(
                            Icons.man,
                            size: pinSize,
                          ))
                    ],
                  ))),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: isPin,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => pinCancel(),
                      label: Text('ยกเลิก'),
                      icon: Icon(
                        Icons.close,
                        size: 30.sp,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: pinList.length != index
                          ? () async {
                              await _loadingState();
                              pinList[index].addPosition(position);
                              setState(() {
                                updateDistance();
                                index++;
                                isPin = false;
                              });
                            }
                          : null,
                      label: Text('ตกลง'),
                      icon: Icon(
                        Icons.check,
                        size: 30.sp,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      )),
      floatingActionButton: IconButton.filled(
          color: Theme.of(context).colorScheme.primary,
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          onPressed: opt != null
              ? () {
                  updateGPS();
                }
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'กรุณาทำการปรับเทียบค่า (Calibrate) ก่อน',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ));
                },
          icon: Icon(
            Icons.gps_fixed,
            size: 40.sp,
          )),
    );
  }

  void pinCancel() {
    setState(() {
      if (pinList.length != index) {
        // Value has changed
        pinList.removeAt(index);
      }
      isPin = false;
    });
  }

  Future<void> _calibrate() async {
    List<List<double>> l1 = [[], []];
    List<List<double>> l2 = [[], []];
    pinList.forEach((Pin p) {
      l1[0].add(p.position.latitude);
      l1[1].add(p.position.longitude);
      l2[0].add(p.pinOffset.dx);
      l2[1].add(p.pinOffset.dy);
    });
    var GP = Matrix.fromList(l1, dtype: DType.float64);
    var SP = Matrix.fromList(l2, dtype: DType.float64);
    opt = Optimize(GP, SP);
    opt!.solve();
    await _loadingState();
    var current_gp = Matrix.fromList([
      [lat],
      [long]
    ], dtype: DType.float64);
    var current_sp = opt!.toSP(current_gp);
    myPosition = Offset(current_sp[0][0], current_sp[1][0]);
    log('Screen Position = \n ${current_sp.toString()}');
    log('Global Position = \n ${current_gp.toString()}');
  }

  Future<void> _checkPermission() async {
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
  }

  Future<void> _getCurrentLocation() async {
      Position currentPosition = await Geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(accuracy: LocationAccuracy.best));

      setState(() {
        position = currentPosition;
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

  Future<void> updateGPS() async {
    await _getCurrentLocation();
    var current_gp = Matrix.fromList([
      [lat],
      [long]
    ], dtype: DType.float64);
    var current_sp = opt!.toSP(current_gp);
    log(current_sp.toString());
    log(current_gp.toString());
    setState(() {
      myPosition = Offset(current_sp[0][0], current_sp[1][0]);
    });
  }

  void _startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      updateGPS();
    });
  }

  void updateDistance() {
    if (pinList.length > 1) {
      int end = pinList.length - 1;
      int start = pinList.length - 2;
      double d = Geolocator.distanceBetween(
          pinList[start].position.latitude,
          pinList[start].position.longitude,
          pinList[end].position.latitude,
          pinList[end].position.longitude);
      totalDistance += d;
    } else {
        return;
    }
  }
}

class Pin {
  Offset pinOffset;
  Color pinColor;
  late Position position;
  bool visible = true;
  Pin(this.pinOffset, this.pinColor);

  void addPosition(Position p) {
    position = p;
  }
}
