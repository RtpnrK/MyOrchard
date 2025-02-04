import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/pages/activities.dart';
import 'package:myorchard/pages/createProfile.dart';
import 'package:myorchard/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileMap extends StatefulWidget {
  const ProfileMap({super.key});

  @override
  State<ProfileMap> createState() => _ProfileMapState();
}

class _ProfileMapState extends State<ProfileMap> {
  int indexes = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 100.h,
        title: Center(
            child: Image.asset(
          'assets/images/logo_MyOrchard.png',
          height: 78.h,
          width: 340.w,
        )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CarouselSlider(
            options: CarouselOptions(
                height: 450.h,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) => setState(() {
                      indexes = index;
                    })),
            items: context.watch<ProfileProvider>().list_profiles.isNotEmpty
                ? List.generate(
                    context.watch<ProfileProvider>().list_profiles.length,
                    (index) => Stack(
                      children: [
                        Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Activities();
                              }));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22.5),
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(22.5),
                                        topRight: Radius.circular(22.5)),
                                    child: Image.file(
                                        File(
                                          context
                                              .watch<ProfileProvider>()
                                              .list_profiles[index]
                                              .image,
                                        ),
                                        fit: BoxFit.cover,
                                        height: 302.h,
                                        width: 316.w),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Text(
                                    context.watch<ProfileProvider>().list_profiles[index].name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel_sharp,
                                color: Theme.of(context).colorScheme.error,
                                size: 40.sp,
                              ),
                              onPressed: () {
                                // Handle delete action
                                context.read<ProfileProvider>().removeProfile(
                                    context
                                        .read<ProfileProvider>()
                                        .list_profiles[index]);
                              }),
                        ),
                      ],
                    ),
                  )
                : [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ยังไม่ได้สร้างโปรไฟล์",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.error)),
                        Text("สร้างโปรไฟล์เพื่อเริ่มต้นใช้งาน",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.black.withValues())),
                      ],
                    )
                  ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < context.watch<ProfileProvider>().list_profiles.length; i++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Container(
                    width: indexes == i ? 15 : 10,
                    height: indexes == i ? 15 : 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: indexes == i ? Theme.of(context).colorScheme.secondary : Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
              height: 62.h,
              width: 256.w,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Createprofile();
                  }));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit,
                        color: Theme.of(context).colorScheme.surface,
                        size: 24.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'สร้างโปรไฟล์',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
