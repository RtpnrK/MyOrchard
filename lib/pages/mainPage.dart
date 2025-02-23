import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/calibrate.dart';
import 'package:myorchard/custom_icons/customIcons.dart';
import 'package:myorchard/pages/activities.dart';
import 'package:myorchard/pages/edit_profile.dart';
import 'package:myorchard/pages/profile.dart';

class MainPage extends StatefulWidget {
  final File image;
  final String name;
  final List? plots;
  final int idMap;
  
  const MainPage({super.key, required this.image, required this.name, this.plots, required this.idMap});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageIndex = 1;
  List<String> title = ["แผนที่", "กิจกรรม", "โปรไฟล์"];
  double scaleFactor = 0.2;

  TransformationController viewTranformationController = TransformationController();

  @override
  void initState() {
    Image img = Image.file(widget.image!);
    imageScaling(img);
    super.initState();
  }

  Future<void> imageScaling(Image image) async {
    final ImageStream stream = image.image.resolve(const ImageConfiguration());
    
    final Completer<ui.Image> completer = Completer<ui.Image>();
    stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));

    final ui.Image img = await completer.future;

    var view = ui.PlatformDispatcher.instance.views.first;
    double deviceWidth = view.physicalSize.width;
    double imageWidth = img.width.toDouble();
    scaleFactor = deviceWidth/ imageWidth;
    viewTranformationController.value = Matrix4.identity()*scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> actionList = [
      [ Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: TextButton.icon(
                onPressed: (){
                  showDialog(
                    context: context, 
                    builder: (context) => AlertDialog(
                      title: Text('เลือกโปรไฟล์การปรับเทียบ', style: Theme.of(context).textTheme.headlineSmall,),
                      content: SizedBox(
                        height: 300.h,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.add, size: 20.sp,),
                              title: Text('เพิ่มการปรับเทียบ', style: Theme.of(context).textTheme.bodyMedium,),
                              onTap: (){
                                Navigator.of(context).pop();
                                Navigator.push(context,
                                 MaterialPageRoute(builder: (context) => Calibrate(image: widget.image!, scale: scaleFactor,)));
                              },
                            )
                          ],
                        ),
                      )
                    ));
                },
                label: Text('ปรับเทียบ'),
                iconAlignment: IconAlignment.end,
                icon: ImageIcon(
                  AssetImage('assets/icons/calibrate.png'),
                  size: 30.sp, 
                  color: Theme.of(context).colorScheme.primary,),),
            )],
            [
              Padding(
              padding: EdgeInsets.only(top: 12.h, right: 10.w),
              child: IconButton(
                icon: ImageIcon(
                  AssetImage('assets/icons/upload.png'),
                  size: 32.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h, right: 10.w),
              child: IconButton(
                icon: ImageIcon(
                  AssetImage('assets/icons/messenger.png'),
                  size: 32.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {},
              ),
            ),
            ],
            [Padding(
            padding: EdgeInsets.only(top: 12.h, right: 18.w),
            child: IconButton(
              icon: Icon(
                CustomIcons.edit,
                size: 38.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                print("ID : ${widget.idMap}");
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditProfile(
                    image: widget.image,
                    name: widget.name,
                    plots: widget.plots,
                    idMap: widget.idMap,
                  );
                }));
              },
            ),
          ),]
    ];
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
            title[pageIndex],
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          actions: actionList[pageIndex],
          toolbarHeight: 100.h,
        ),
        extendBody: true,
        bottomNavigationBar: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Container(
                height: 80.h,
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
        body: [
          Center(
              child: InteractiveViewer(
                  minScale: 0.2,
                  transformationController: viewTranformationController,
                  constrained: false,
                  child: Image(image: FileImage(widget.image)))),
          Activities(),
          Profile(
            image: widget.image,
            name: widget.name,
            plots: widget.plots, 
            idMap: widget.idMap,
          )
        ][pageIndex]);
  }
}
