import 'package:flutter/material.dart';

class Calibrate extends StatefulWidget {
  const Calibrate({super.key});
  @override
  CalibrateState createState() => CalibrateState();
}

class CalibrateState extends State<Calibrate> {
  Offset imgOffset = const Offset(0, 0);
  String offsetShow = "Pixel Offset:";
  bool isPress = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InteractiveViewer(
          child: SizedBox(
            width: 400,
            height: 400,
            child: LayoutBuilder(builder: (context, constraints) {
              return GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    if (isPress) {
                      imgOffset = details.localPosition;
                      String dx = imgOffset.dx.toStringAsFixed(10);
                      String dy = imgOffset.dy.toStringAsFixed(10);
                      offsetShow = "Pixel Offset: $dx, $dy";
                    }
                  });
                },
                child: Stack(
                  children: [
                    Image.asset("assets/images/map1.png", fit: BoxFit.contain),
                    if (isPress)
                      Positioned(
                          left: imgOffset.dx - 10,
                          top: imgOffset.dy - 20,
                          child: Icon(Icons.location_pin,
                              color: Colors.red, size: 20))
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: !isPress,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isPress = true;
                    });
                  },
                  icon: Icon(Icons.location_pin, size: 30, color: Colors.red)),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    isPress = false;
                  });
                },
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
        Text(offsetShow)
      ],
    ));
  }
}
