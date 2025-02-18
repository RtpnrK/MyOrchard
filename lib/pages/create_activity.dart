import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myorchard/pickImage.dart';

class CreateActivity extends StatefulWidget {
  const CreateActivity({super.key});

  @override
  State<CreateActivity> createState() => _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {
  File? selectedImage;
  TextEditingController treeController = TextEditingController();

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

  void showOption() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 180.h,
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('เลือกรูปจาก'),
                  ElevatedButton.icon(
                    icon: Icon(Icons.photo_size_select_actual_rounded),
                    iconAlignment: IconAlignment.end,
                    label: const Text('เลือกรูปจากแกลเลอรี่'),
                    style:
                        ElevatedButton.styleFrom(fixedSize: Size(400.w, 10.h)),
                    onPressed: () => selectImageGallery(),
                  ),
                  ElevatedButton.icon(
                      onPressed: () => selectImageCamera(),
                      icon: Icon(Icons.camera_alt_outlined),
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(400.w, 10.h)),
                      label: Text("ถ่ายรูป"))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'สร้างกิจกรรม',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: Column(
            children: [
              Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22.5))),
                child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(22.5)),
                    onTap: () => showOption(),
                    child: selectedImage != null
                        ? SizedBox(
                            width: 360.w,
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
                            width: 360.w,
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
                                  color: Theme.of(context).colorScheme.primary,
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
                child: SizedBox(
                  width: 360.w,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                    child: Column(
                      children: [
                        Row(
                          spacing: 10.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 180.w,
                              height: 45.h,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 20.sp
                                ),
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                controller: treeController,
                                decoration: InputDecoration(
                                  label: Text("ต้น"),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 135.w,
                              height: 45.h,
                              child: TextField(
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                readOnly: true, // ทำให้ไม่สามารถแก้ไขได้
                                decoration: InputDecoration(

                                    //labelText: DateTime.now().toString(),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText:
                                        DateFormat.yMd().format(DateTime.now()),
                                    hintStyle: TextStyle(fontSize: 20.sp)),
                                controller: TextEditingController(text: ""),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
