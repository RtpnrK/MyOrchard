import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import '../pickImage.dart';

class Createprofile extends StatefulWidget {
  const Createprofile({super.key});

  @override
  State<Createprofile> createState() => _CreateprofileState();
}

class _CreateprofileState extends State<Createprofile> {
  File? selectedImage;
  final mapNameController = TextEditingController();
  final List listPlotController = [TextEditingController()];

  Future<void> selectImage() async {
    final image = await pickImage(); // Call the function
    setState(() {
      selectedImage = image; // Update the state with the picked image
    });
  }

  void addPlot() {
    setState(() {
      listPlotController.add(TextEditingController());
    });
  }

  void removePlot(int index) {
    setState(() {
      listPlotController.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                size: 42.h,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          toolbarHeight: 75.h,
          title: Text(
            'สร้างโปรไฟล์',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Column(
                spacing: 50.h,
                children: [
                  Card(
                    child: InkWell(
                        onTap: () => {selectImage()},
                        child: selectedImage != null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(22.5),
                                ),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                  height: 366.h,
                                  width: 366.w,
                                ),
                              )
                            : Container(
                                height: 366.h,
                                width: 366.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_upload_sharp,
                                      size: 50.h,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    Text('เลือกรูปภาพ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )),
                                  ],
                                ),
                              )),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 52.h,
                          width: 366.w,
                          child: TextField(
                            controller: mapNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'ชื่อโปรไฟล์',
                              hintText: 'กรอกชื่อโปรไฟล์',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35.h,
                        ),
                        SizedBox(
                          height: 52.h,
                          width: 366.w,
                          child: ListView.builder(
                            //shrinkWrap: true,
                            itemCount: listPlotController.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: TextField(
                                    controller: listPlotController[index],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'แปลง',
                                      hintText: 'เพิ่มแปลง',
                                      suffixIcon: IconButton(
                                        icon: index ==
                                                listPlotController.length - 1
                                            ? Icon(Icons.add)
                                            : Icon(Icons.remove),
                                        onPressed: () {
                                          index == listPlotController.length - 1
                                              ? addPlot()
                                              : removePlot(index);
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 62.h,
                      width: 366.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          print("add profile");
                          selectedImage == null
                              ? null
                              : context.read<ProfileProvider>().addProfile(
                                  selectedImage!.path,
                                  mapNameController.text,
                                  listPlotController
                                      .map((listPlot) => listPlot.text)
                                      .toList());

                          print(
                              "จำนวน : ${context.read<ProfileProvider>().list_profiles.length}");
                          context
                              .read<ProfileProvider>()
                              .list_profiles
                              .forEach((element) {
                            print("ชื่อ : ${element.name}");
                            print("รูป : ${element.image}");
                            print("แปลง : ${element.profile}");
                          });

                          // Navigator.push(context, MaterialPageRoute(builder: (context) {
                          //   return ProfileMap();
                          // }));
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit,
                                color: Theme.of(context).colorScheme.surface,
                                size: 24.sp),
                            SizedBox(width: 8.w),
                            Text(
                              'ยืนยัน',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
