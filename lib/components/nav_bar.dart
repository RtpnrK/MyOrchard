import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/calibrate_old.dart';
import 'package:myorchard/pages/activities.dart';
import 'package:myorchard/pages/profile.dart';
import 'package:myorchard/providers/activity_provider.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  final File image;
  final String name;
  final List? plots;
  final int idMap;
  const NavBar(
      {super.key,
      required this.image,
      required this.name,
      this.plots,
      required this.idMap});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    print("Plots = ${widget.plots}");
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> page = [
      Calibrate(),
      Activities2(plots: widget.plots, idMap: widget.idMap),
      Profile(
        image: widget.image,
        name: widget.name,
        plots: widget.plots,
        idMap: widget.idMap,
      )
    ];
    return Scaffold(
      bottomNavigationBar: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              height: 75.h,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ########## Map #########
              Container(
                margin: pageIndex == 0 ? null : EdgeInsets.only(top: 20),
                height: 75.h,
                width: 75.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pageIndex == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    icon: ImageIcon(
                      AssetImage('assets/icons/map.png'),
                      size: 40.sp,
                      color: pageIndex == 0
                          ? Colors.white
                          : Theme.of(context).colorScheme.secondary,
                    )),
              ),
              // ########## Activity ##########
              Container(
                margin: pageIndex == 1 ? null : EdgeInsets.only(top: 20),
                height: 75.h,
                width: 75.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pageIndex == 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        pageIndex = 1;
                      });
                    },
                    icon: ImageIcon(
                      AssetImage('assets/icons/gardening.png'),
                      size: 40.sp,
                      color: pageIndex == 1
                          ? Colors.white
                          : Theme.of(context).colorScheme.secondary,
                    )),
              ),
              // ########## Profile ##########
              Container(
                margin: pageIndex == 2 ? null : EdgeInsets.only(top: 20),
                height: 75.h,
                width: 75.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pageIndex == 2
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        pageIndex = 2;
                      });
                    },
                    icon: Icon(
                      Icons.person,
                      size: 40.sp,
                      color: pageIndex == 2
                          ? Colors.white
                          : Theme.of(context).colorScheme.secondary,
                    )),
              ),
            ],
          )
        ],
      ),
      body: page[pageIndex],
    );
  }
}
