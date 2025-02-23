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
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22.5))),
                  child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(22.5)),
                      onTap: () => selectImageGallery(),
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 28.w, bottom: 10.h),
                          child: Text(
                            'ชื่อสวน',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: SizedBox(
                          height: 52.h,
                          child: TextField(
                            controller: mapNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              hintText: 'กรอกชื่อโปรไฟล์',
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
                          padding: EdgeInsets.only(left: 28.w, top: 10.h),
                          child: Text(
                            'แปลง',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                      Center(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                                left: 20.w, right: 20.w, bottom: 10.h),
                            shrinkWrap: true,
                            itemCount: listPlotController.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    height: 52.h,
                                    child: TextField(
                                      controller: listPlotController[index],
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'ชื่อแปลง',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 10,
                                      child: IconButton(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h),
                                          onPressed: () => removePlot(index),
                                          icon: Icon(Icons.remove)))
                                ],
                              );
                            }),
                      ),
                      InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              listPlotController.add(TextEditingController());
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.w),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 30.sp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                Text(
                                  'เพิ่มแปลง',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
        height: 80.h,
        child: ElevatedButton.icon(
          onPressed: () {
            print("add map");
            selectedImage == null
                ? null
                : context.read<MapProvider>().addProfile(
                    selectedImage!.path,
                    mapNameController.text,
                    listPlotController
                        .map((listPlot) => listPlot.text)
                        .toList());
            print(
                "จำนวน  : ${context.read<MapProvider>().list_profiles.length}");
            // context.read<mapProvider>().list_maps.forEach((element) {
            //   print("ชื่อ : ${element.name}");
            //   print("รูป : ${element.image}");
            //   print("แปลง : ${element.plots}");
            // });
            Navigator.pop(context);
          },
          label: Text('ยืนยัน',style:TextStyle(color: Colors.white, fontSize: 22.sp),),
          icon: Icon(Icons.create,size: 28.sp,),
        ),
      ),
    );
  }
}
