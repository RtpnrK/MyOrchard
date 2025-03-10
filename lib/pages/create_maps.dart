import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorchard/providers/map_provider.dart';
import 'package:provider/provider.dart';

import '../pickImage.dart';

class CreateMaps extends StatefulWidget {
  const CreateMaps({super.key});

  @override
  State<CreateMaps> createState() => _CreateMapsState();
}

class _CreateMapsState extends State<CreateMaps> {
  File? selectedImage;
  final mapNameController = TextEditingController();
  final List listPlotController = [];

  Future<void> selectImageGallery() async {
    final image = await pickImage(ImageSource.gallery); // Call the function
    setState(() {
      selectedImage = image; // Update the state with the picked image
    });
  }

  Future<void> selectImageCamera() async {
    final image = await pickImage(ImageSource.camera); // Call the function
    setState(() {
      selectedImage = image; // Update the state with the picked image
    });
  }

  void removePlot(int index) {
    setState(() {
      listPlotController.removeAt(index);
    });
  }

  @override
  void dispose() {
    mapNameController.dispose();
    for (var controller in listPlotController) {
      controller.dispose();
    }
    super.dispose();
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
            padding: EdgeInsets.only(top: 10.h),
            child: Column(
              spacing: 10.h,
              children: [
                Card(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22.5))),
                  child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(22.5)),
                      onTap: () => selectImageGallery(),
                      child: selectedImage != null
                          ? SizedBox(
                              width: 380.w,
                              height: 300.h,
                              child: Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22.5)),
                                    image: DecorationImage(
                                        image: FileImage(selectedImage!),
                                        fit: BoxFit.cover)),
                              ),
                            )
                          : Container(
                              height: 300.h,
                              width: 380.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
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
                Card(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                    child: SizedBox(
                      height: (listPlotController.isEmpty ||
                              listPlotController.length <= 2)
                          ? 360.h
                          : null,
                      width: 380.w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20.w, top: 10.h, bottom: 8.h),
                                child: Text(
                                  'ชื่อสวน',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              child: SizedBox(
                                height: 60.h,
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(fontSize: 21.sp),
                                  controller: mapNameController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    label: Text('ตั้งชื่อสวนของคุณ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20.w, top: 10.h, bottom: 8.h),
                                child: Text(
                                  'แปลง',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                            Center(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                      left: 20.w, right: 20.w, bottom: 8.h),
                                  shrinkWrap: true,
                                  itemCount: listPlotController.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          height: 60.h,
                                          child: TextField(
                                            style: TextStyle(fontSize: 21.sp),
                                            controller:
                                                listPlotController[index],
                                            decoration: InputDecoration(
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                filled: true,
                                                fillColor: Colors.white,
                                                label: Text(
                                                  "แปลงที่ ${index + 1}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                suffixIcon: IconButton(
                                                    onPressed: () =>
                                                        removePlot(index),
                                                    icon: Icon(
                                                      Icons.remove,
                                                      size: 30.sp,
                                                    ))),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    listPlotController
                                        .add(TextEditingController());
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25.w),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 30.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      Text(
                                        'เพิ่มแปลง',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(color: Colors.black),
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: 10.h, right: 20.w, left: 20.w),
                  child: SizedBox(
                    height: 60.h,
                    width: 380.w,
                    child: ElevatedButton.icon(
                      iconAlignment: IconAlignment.start,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (mapNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("กรุณากรอกชื่อสวน"),
                          ));
                          return;
                        }

                        context.read<MapProvider>().addProfile(
                            selectedImage?.path ?? '',
                            mapNameController.text,
                            listPlotController
                                .map((listPlot) => listPlot.text)
                                .toList());
                        Navigator.pop(context);
                      },
                      label: Text(
                        'ยืนยัน',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                      ),
                      icon: Icon(
                        Icons.create,
                        size: 28.sp,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
