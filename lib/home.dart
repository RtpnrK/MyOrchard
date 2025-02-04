import 'dart:io';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:myorchard/manage.dart';
import 'package:myorchard/selectMap.dart';


class Profile extends StatelessWidget {
  const Profile({super.key, required this.img, required this.title});
  final File img;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            elevation: 20,
            shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            child: InkWell(
              customBorder:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PickerButt()));
              },
              child: const SizedBox(
                  width: 320,
                  height: 400,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 100,
                      color: Colors.black38,
                    ),
                  ),
                ),
            ),
          )
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
  final List<Widget> profiles = [

  ];
  int pageIndex = 0;

  @override
  void initState() {
    setState(() {
      print(widget.img);
      if (widget.img != null && widget.title != null) {
        profiles.add(Profile(
          img: widget.img!,
          title: widget.title!,
        ));
        profiles.insert(profiles.length, 
        Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            customBorder:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PickerButt()));
              },
            child: const SizedBox(
                  width: 320,
                  height: 400,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 100,
                      color: Colors.black38,
                    ),
                  ),
                ),
          ),
        ));
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
                    height: 50,
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