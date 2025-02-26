import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorchard/models/maps_model.dart';
import 'package:myorchard/pickImage.dart';
import 'package:myorchard/providers/map_provider.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final File image;
  final String name;
  final List? plots;
  final int idMap;
  const EditProfile(
      {super.key,
      required this.image,
      required this.name,
      this.plots,
      required this.idMap});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? selectedImage;
  late TextEditingController mapNameController;
  List<TextEditingController> listPlotController = [];
  Future<void> selectImageGallerry() async {
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
  void initState() {
    super.initState();
    print("Plot = ${widget.plots}");
    mapNameController = TextEditingController(text: widget.name);
    selectedImage = widget.image;
    listPlotController = widget.plots
            ?.map((plot) => TextEditingController(text: plot))
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
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
          "แก้ไขโปรไฟล์",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        toolbarHeight: 100.h,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: Column(
              spacing: 15.h,
              children: [
                Card(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22.5))),
                  child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(22.5)),
                      onTap: () => selectImageGallerry(),
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
                          : SizedBox(
                              width: 380.w,
                              height: 300.h,
                              child: Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22.5)),
                                    image: DecorationImage(
                                        image: FileImage(widget.image),
                                        fit: BoxFit.cover)),
                              ),
                            )),
                ),
                Card(
                  child: SizedBox(
                    width: 380.w,
                    child: Column(
                      spacing: 10.h,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 28.w, bottom: 10.h, top: 20.h),
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
                                listPlotController.add(TextEditingController(
                                    text:
                                        'แปลงที่ ${listPlotController.length + 1}'));
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 180.w,
              height: 58.h,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(fontSize: 25.sp),
                ),
              ),
            ),
            SizedBox(
              width: 180.w,
              height: 58.h,
              child: FilledButton(
                onPressed: () {
                  List<String> plotList = listPlotController
                      .map((controller) => controller.text)
                      .toList();
                  context.read<MapProvider>().updateProfile(MapsModel(
                      image: selectedImage!.path,
                      name: mapNameController.text,
                      id: widget.idMap,
                      plots: plotList));
                  Navigator.pop(context);
                },
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(fontSize: 25.sp),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
