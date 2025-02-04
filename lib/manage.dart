import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myorchard/activities.dart';
import 'package:myorchard/calibeate.dart';

class Manage extends StatefulWidget {
  final File? image;
  const Manage({super.key, this.image});

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  late double width, height;
  TransformationController viewTranformationController =
      TransformationController();

  @override
  void initState() {
    viewTranformationController =
        TransformationController(Matrix4.identity()..scale(0.3));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                spreadRadius: 5,
                offset: Offset(0, 2)
              )],
              color: Color(0xff5D8736),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
              )
            ),
            width: width,
            height: height*0.2,
            child:  Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    child:  Image.asset('assets/logo/Logo.png'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text('Orchard\nManagement',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              // Activities
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                color: const Color(0xffA9C46C),
                elevation: 8,
                child: InkWell(
                  customBorder: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(40))),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Activities()));
                  },
                  child: SizedBox(
                    width: width * 0.9,
                    height: height * 0.13,
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        ImageIcon(
                          AssetImage('assets/icons/gardening.png'),
                          color: Colors.white,
                          size: 50,),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Activities',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // Map
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                color: const Color(0xff577BC1),
                elevation: 8,
                child: InkWell(
                  customBorder: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(40))),
                  onTap: () {
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => Calibrate(image: widget.image,)));
                  },
                  child: SizedBox(
                    width: width * 0.9,
                    height: height * 0.13,
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        ImageIcon(
                          AssetImage('assets/icons/map.png'),
                          color: Colors.white,
                          size: 50,),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Map',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // Chat
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                color: const Color(0xffD0DDD0),
                elevation: 8,
                child: InkWell(
                  customBorder: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(40))),
                  onTap: () {},
                  child: SizedBox(
                    width: width * 0.9,
                    height: height * 0.13,
                    child:  const Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        ImageIcon(
                          AssetImage('assets/icons/messenger.png'),
                          color: Colors.black,
                          size: 50,),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Chat',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  } 
}
