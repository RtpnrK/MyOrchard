import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:myorchard/calibrate.dart';
import 'package:myorchard/selectMap.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.img, required this.title});
  final File img;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SizedBox(
              width: 320,
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 85,
                    foregroundImage: FileImage(img),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {},
                          child: const Text('Edit',
                              style: TextStyle(fontSize: 18))),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Calibrate(image: img,)));
                          },
                          child: const Text('Select',
                              style: TextStyle(fontSize: 18)))
                    ],
                  )
                ],
              ),
            )),
        Positioned(
            top: 10,
            right: 10,
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                                'Are you sure you want to remove this map?'),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No',
                                      style: TextStyle(fontSize: 18))),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Yes',
                                      style: TextStyle(fontSize: 18)))
                            ],
                          ));
                },
                icon: const Icon(Icons.clear)))
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'My Orchard',
            style: TextStyle(
              fontSize: 45,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: SizedBox(
                  width: 320,
                  height: 400,
                  child: Center(
                      child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PickerButt()));
                    },
                    label: const Text('Add New'),
                    icon: const Icon(Icons.add),
                  )))),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  final File? img;
  final String? title;
  const Home({super.key, this.img, this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> profiles = [];
  int pageIndex = 0;

  @override
  void initState() {
    setState(() {
      print(widget.title);
      if (widget.img != null && widget.title != null) {
      profiles.add(Profile(img: widget.img!, title: widget.title!,));
    }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: profiles.isEmpty
          ? const EmptyState()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'My Orchard',
                    style: TextStyle(
                      fontSize: 45,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CarouselSlider(
                      items: profiles,
                      options: CarouselOptions(
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              pageIndex = index;
                            });
                          },
                          height: 400)),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < profiles.length; i++)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Container(
                            width: pageIndex == i ? 15 : 10,
                            height: pageIndex == i ? 15 : 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: pageIndex == i ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PickerButt()));
                    },
                    label: const Text('Add New'),
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
            ),
    );
  }
}
