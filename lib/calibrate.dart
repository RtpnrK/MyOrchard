import 'dart:io';

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    print(widget.image);
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
                          ? Image.file(widget.image!,height: MediaQuery.of(context).size.height/2,width:MediaQuery.of(context).size.width ,)
                          : Image.asset("assets/images/map1.png",
                              fit: BoxFit.contain),
                      if (isPress)
                        Positioned(
                            left: imgOffset.dx - 10,
                            top: imgOffset.dy - 20,
                            child: Icon(Icons.location_pin,
                                color: Colors.red, size: 20))
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
                        });
                      },
                      child: Text("Cancel"))),
              Visibility(
                  visible: isPin,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: OutlinedButton(onPressed: () {}, child: Text("Apply")))
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
                      });
                    },
                    icon:
                        Icon(Icons.location_pin, size: 30, color: Colors.red)),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Colors.blue,
                  ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(offsetShow),
        ],
      )),
    );
  }
}
