import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorchard/models/activities_model.dart';
import 'package:myorchard/pickImage.dart';
import 'package:myorchard/providers/activity_provider.dart';
import 'package:provider/provider.dart';

class EditActivity extends StatefulWidget {
  final ActivitiesModel activity;
  final List? plots;
  const EditActivity({super.key, required this.activity, this.plots});

  @override
  State<EditActivity> createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  File? selectedImage;
  late TextEditingController treeController;
  late TextEditingController activityController;
  String plotSelected = '';
  late TextEditingController detailController;
  String date = "";

  @override
  void initState() {
    super.initState();
    treeController = TextEditingController(text: widget.activity.tree);
    activityController = TextEditingController(text: widget.activity.activity);
    detailController = TextEditingController(text: widget.activity.details);
    plotSelected = widget.activity.plot!;
    date = widget.activity.date!;
    selectedImage = File(widget.activity.image!);
  }

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

  @override
  Widget build(BuildContext context) {
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
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(400.w, 10.h)),
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
          'แก้ไขกิจกรรม',
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
                            child: Ink(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22.5)),
                                  image: DecorationImage(
                                      image: widget.activity.image!.isEmpty
                                          ? AssetImage('assets/images/noimage.png')
                                          : FileImage(File(widget.activity.image!)),
                                      fit: BoxFit.cover)),
                            ),
                          )),
              ),
              Card(
                child: SizedBox(
                  width: 380.w,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                    child: Column(
                      spacing: 10.h,
                      children: [
                        Row(
                          spacing: 10.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 195.w,
                              height: 60.h,
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: TextStyle(
                                  fontSize: 21.sp,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.start,
                                controller: activityController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  label: Text(
                                    "กิจกรรม",
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 135.w,
                              height: 60.h,
                              child: TextField(
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                readOnly: true, // ทำให้ไม่สามารถแก้ไขได้
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: TextEditingController(
                                  text: date,
                                ),
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 10.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 140.w,
                              height: 60.h,
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 21.sp,
                                    overflow: TextOverflow.ellipsis),
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.start,
                                controller: treeController,
                                decoration: InputDecoration(
                                  label: Text(
                                    "ต้น",
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 190.w,
                              height: 60.h,
                              child: DropdownButtonFormField2(
                                  value: plotSelected.isEmpty
                                      ? null
                                      : plotSelected, // ให้เลือกแปลงที่ไม่ซ้ำกัน
                                  isExpanded: true,
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                      // isDense: true,

                                      label: Text(
                                        "แปลง",
                                        style: TextStyle(fontSize: 18.sp),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                  items: widget.plots!.map((plot) {
                                    return DropdownMenuItem(
                                      value: plot,
                                      child: Text(plot.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      plotSelected = value as String;
                                      print("value = $value");
                                    });
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 340.w,
                          height: 240.h,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: TextStyle(
                              fontSize: 21.sp,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            controller: detailController,
                            decoration: InputDecoration(
                              label: Text(
                                "รายละเอียด",
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
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
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                    backgroundColor: WidgetStatePropertyAll(Colors.redAccent)),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            SizedBox(
              width: 180.w,
              height: 58.h,
              child: FilledButton(
                onPressed: () {
                  context.read<ActivityProvider>().updateActivity(
                      ActivitiesModel(
                          id: widget.activity.id,
                          image: selectedImage!.path,
                          tree: treeController.text,
                          details: detailController.text,
                          activity: activityController.text,
                          plot: plotSelected,
                          date: date,
                          profileId: widget.activity.profileId));

                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                    backgroundColor: WidgetStatePropertyAll(Colors.green)),
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
