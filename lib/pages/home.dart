import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/pages/mainPage.dart';
import 'package:myorchard/pages/create_maps.dart';
import 'package:myorchard/providers/map_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indexes = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();

    //ตรวจสอบว่าโปรไฟล์มีข้อมูลหรือไม่
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapProvider>().loadProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 100.h,
        title: Center(
            child: Image.asset(
          'assets/images/logo_MyOrchard.png',
          height: 100.h,
          width: 360.w,
        )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
                height: 450.h,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) => setState(() {
                      indexes = index;
                    })),
            items: context.watch<MapProvider>().list_profiles.isNotEmpty
                ? List.generate(
                    context.watch<MapProvider>().list_profiles.length,
                    (index) => Stack(
                      children: [
                        Card(
                            child: SizedBox(
                          width: 320.w,
                          height: 450.h,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage(
                                            image: File(
                                              context
                                                  .watch<MapProvider>()
                                                  .list_profiles[index]
                                                  .image,
                                            ),
                                            name: context
                                                .watch<MapProvider>()
                                                .list_profiles[index]
                                                .name ,
                                            plots: context
                                                .watch<MapProvider>()
                                                .list_profiles[index]
                                                .plots,
                                            idMap: context
                                                    .watch<MapProvider>()
                                                    .list_profiles[index]
                                                    .id ??
                                                0,
                                          )
                                      ));
                            },
                            onLongPress: () {
                              showDialog(
                                    context: context,
                                    builder: (BuildContext) {
                                      return AlertDialog(
                                        title: Text(
                                          'ยืนยันการลบโปรไฟล์',
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 25.sp),
                                        ),
                                        content: Text(
                                          'คุณต้องการลบโปรไฟล์นี้ใช่หรือไม่?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('ยกเลิก')),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _carouselController.previousPage();
                                                  context.read<MapProvider>().removeProfile(
                                                      context
                                                          .read<MapProvider>()
                                                          .list_profiles[index]);
                                                });
                                                // Handle delete action
                                                Navigator.pop(context);
                                              },
                                              child: Text('ยืนยัน'))
                                        ],
                                      );
                                    });
                            },
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(22.5),
                                            topRight: Radius.circular(22.5)),
                                        image: DecorationImage(
                                            image: FileImage(File(
                                              context
                                                  .watch<MapProvider>()
                                                  .list_profiles[index]
                                                  .image,
                                            )),
                                            fit: BoxFit.cover),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        context
                                            .watch<MapProvider>()
                                            .list_profiles[index]
                                            .name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        )),
                        // Positioned(
                        //   top: 8.0,
                        //   right: 8.0,
                        //   child: IconButton(
                        //       icon: Icon(
                        //         Icons.cancel_sharp,
                        //         color: Theme.of(context).colorScheme.error,
                        //         size: 40.sp,
                        //       ),
                        //       onPressed: () {
                        //         setState(() {
                        //           _carouselController.previousPage();
                        //           context.read<MapProvider>().removeProfile(
                        //               context
                        //                   .read<MapProvider>()
                        //                   .list_profiles[index]);
                        //         });
                        //         // Handle delete action
                        //       }),
                        // ),
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
              for (int i = 0;
                  i < context.watch<MapProvider>().list_profiles.length;
                  i++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Container(
                    width: indexes == i ? 15 : 10,
                    height: indexes == i ? 15 : 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: indexes == i
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
              height: 62.h,
              width: 320.w,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateMaps()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
