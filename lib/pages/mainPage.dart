import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/calibrate.dart';
import 'package:myorchard/custom_icons/customIcons.dart';
import 'package:myorchard/database/activities_db.dart';
import 'package:myorchard/models/activities_model.dart';
import 'package:myorchard/pages/activities.dart';
import 'package:myorchard/pages/chat.dart';
import 'package:myorchard/pages/create_activity.dart';
import 'package:myorchard/pages/edit_profile.dart';
import 'package:myorchard/pages/profile.dart';
import 'package:myorchard/providers/pins_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final File image;
  final String name;
  final List? plots;
  final int idMap;

  const MainPage(
      {super.key,
      required this.image,
      required this.name,
      this.plots,
      required this.idMap});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageIndex = 1;
  List<String> title = ["แผนที่", "กิจกรรม", "โปรไฟล์"];
  double scaleFactor = 0.2;

  TransformationController viewTranformationController =
      TransformationController();

  @override
  void initState() {
    Image img = Image.file(widget.image);
    imageScaling(img);
    context.read<PinsProvider>().loadPins(widget.idMap);
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
    scaleFactor = deviceWidth / imageWidth;
    viewTranformationController.value = Matrix4.identity() * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> actionList = [
      [
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Calibrate(
                            image: widget.image,
                            scale: scaleFactor,
                            profileId: widget.idMap,
                          )));
            },
            label: Text('ปรับเทียบ'),
            iconAlignment: IconAlignment.end,
            icon: ImageIcon(
              AssetImage('assets/icons/calibrate.png'),
              size: 30.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        )
      ],
      [
        Padding(
          padding: EdgeInsets.only(top: 12.h, right: 10.w),
          child: IconButton(
            icon: ImageIcon(
              AssetImage('assets/icons/upload.png'),
              size: 32.sp,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              export2csv();
            },
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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Chat(
                  profileId: widget.idMap,
                );
              }));
            },
          ),
        ),
      ],
      [
        Padding(
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
        ),
      ]
    ];
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(top: 12.h, left: 10.w),
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult:(didPop, result) {
              if (didPop) {
                return;
              }
              backDialog(context);
            },
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 40.h,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                backDialog(context);
              },
            ),
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
        Activities(plots: widget.plots, idMap: widget.idMap),
        Profile(
          image: widget.image,
          name: widget.name,
          plots: widget.plots,
          idMap: widget.idMap,
        )
      ][pageIndex],
      floatingActionButton: [
        null,
        SizedBox(
          width: 60.w,
          height: 60.h,
          child: IconButton.filled(
            style: IconButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreateActivity(
                  idMap: widget.idMap,
                  plots: widget.plots,
                );
              }));
            },
            icon: Icon(Icons.add, size: 30.sp,)),
        ),
        null
      ][pageIndex],
    );
  }

  void backDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'กลับสู่หน้าเลือกโปรไฟล์ใช่หรือไม่?',
              style: TextStyle(fontSize: 20.sp),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20.sp),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20.sp),
                  ))
            ],
          );
        });
  }

  Future<void> export2csv() async {
    List<String> header = ['ชื่อ', 'กิจกรรม', 'รายละเอียด', 'วันที่'];
    List<List<String>> data = [];
    List<ActivitiesModel> activitiesList = await ActivitiesDb().getActivities(widget.idMap);
    for (int i = 0; i < activitiesList.length; i++) {
      data.add([
        activitiesList[i].tree!, 
        activitiesList[i].activity!,
        activitiesList[i].details!,
        activitiesList[i].date!]);
    }
    data.reversed;
    data.insert(0, header);
    String csv = ListToCsvConverter().convert(data);
    Uint8List csvBytes = utf8.encode(csv); 
    
    await FilePicker.platform.saveFile(
      bytes: csvBytes,
      dialogTitle: 'Save CSV File',
      fileName: 'data.csv',
    );
  }
}
