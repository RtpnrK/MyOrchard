import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorchard/models/activities_model.dart';
import 'package:myorchard/pickImage.dart';
import 'package:myorchard/providers/activity_provider.dart';
import 'package:myorchard/providers/map_provider.dart';
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
  late TextEditingController executorController;
  String activity = '';
  bool other = false;

  @override
  void initState() {
    super.initState();
    treeController = TextEditingController(text: widget.activity.tree);
    detailController = TextEditingController(text: widget.activity.details);
    executorController = TextEditingController(text: widget.activity.executor);
    activityController = TextEditingController();
    plotSelected = widget.activity.plot!;
    date = widget.activity.date!;
    activity = widget.activity.activity!;
    if (widget.activity.image!.isNotEmpty) {
      selectedImage = File(widget.activity.image!);
    }
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
    List<String> activitySet = ['อื่นๆ(ระบุ)', 'ใส่ปุ๋ย', 'รดน้ำ', 'ใส่ยา', 'พรวนดิน', 'ตัดหญ้า'];
    bool inSet = false;
    for (var a in activitySet) {
      if(activity == a){
        inSet = true;
      }
    }
    if (!inSet) {
      activityController = TextEditingController(text: activity.substring(8));
      activity = 'อื่นๆ(ระบุ)';
      other = true;
    }
    void showOption() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 250.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22.5),
                    topRight: Radius.circular(22.5)),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'เลือกรูปจาก',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      width: 280.w,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.photo_size_select_actual_rounded,
                          size: 30.sp,
                        ),
                        iconAlignment: IconAlignment.end,
                        label: Text(
                          'เลือกรูปจากแกลเลอรี่',
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        onPressed: () {
                          selectImageGallery();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: 280.w,
                      child: ElevatedButton.icon(
                          onPressed: () => selectImageCamera(),
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            size: 30.sp,
                          ),
                          iconAlignment: IconAlignment.end,
                          label: Text(
                            "ถ่ายรูป",
                            style: TextStyle(fontSize: 18.sp),
                          )),
                    )
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
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
            child: Column(
              spacing: 5.h,
              children: [
                Card(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22.5))),
                  child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(22.5)),
                      onTap: () => showOption(),
                      child: SizedBox(
                        width: 380.w,
                        height: 300.h,
                        child: widget.activity.image!.isNotEmpty
                            ? Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22.5)),
                                    image: DecorationImage(
                                        image: FileImage(selectedImage!),
                                        fit: BoxFit.cover)),
                              )
                            : Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22.5)),
                                    image: DecorationImage(
                                        image: widget.activity.image!.isEmpty
                                            ? AssetImage(
                                                'assets/images/noimage.png')
                                            : FileImage(
                                                File(widget.activity.image!)),
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
                        spacing: 20.h,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: Row(
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
                                    controller: treeController,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      label: Text(
                                        "ชื่อ",
                                        style: TextStyle(fontSize: 24.sp),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.5),
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
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.5),
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
                          ),
                          SizedBox(
                            width: 340.w,
                            height: 60.h,
                            child: DropdownButtonFormField2(
                              value: activity,
                              isExpanded: true,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  // isDense: true,
                                  label: Text(
                                    "กิจกรรม",
                                    style: TextStyle(fontSize: 24.sp),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.5))),
                              items: List.generate(
                                  activitySet.length,
                                  (index) => DropdownMenuItem(
                                        value: activitySet[index],
                                        child: Text(
                                          activitySet[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      )),
                              onChanged: (value) {
                                setState(() {
                                  activity = value!;
                                });
                                if (value == 'อื่นๆ(ระบุ)') {
                                  setState(() {
                                    other = true;
                                  });
                                } else {
                                  setState(() {
                                    other = false;
                                  });
                                }
                              },
                            ),
                          ),
                          Visibility(
                            visible: other,
                            child: SizedBox(
                              width: 340.w,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 21.sp,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.start,
                                controller: activityController,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  label: Text(
                                    "ระบุกิจกรรม",
                                    style: TextStyle(fontSize: 24.sp),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 340.w,
                            height: 100.h,
                            child: TextField(
                              expands: true,
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
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                floatingLabelStyle: TextStyle(fontSize: 24.sp),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.5),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 340.w,
                            height: 60.h,
                            child: DropdownButtonFormField2(
                                isExpanded: true,
                                style: Theme.of(context).textTheme.bodySmall,
                                decoration: InputDecoration(
                                    // isDense: true,
                                    label: Text(
                                      widget.plots!.isEmpty
                                          ? "ไม่มีแปลง"
                                          : "แปลง",
                                      style: TextStyle(fontSize: 24.sp),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.5))),
                                items: widget.plots!.map((plot) {
                                  return DropdownMenuItem(
                                    value: plot,
                                    child: Text(plot.toString()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    print("value = $value");
                                    plotSelected = value as String;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: 340.w,
                            height: 60.h,
                            child: TextField(
                              style: TextStyle(
                                fontSize: 21.sp,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              controller: executorController,
                              decoration: InputDecoration(
                                label: Text(
                                  "ผู้ปฎิบัติการ",
                                  style: TextStyle(fontSize: 24.sp),
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.5),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
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
                            style: TextStyle(fontSize: 28.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 180.w,
                        height: 58.h,
                        child: FilledButton(
                          onPressed: () {
                            if (other) {
                              setState(() {
                                activity = '(อื่นๆ) ${activityController.text}';
                              });
                            }
                            context.read<ActivityProvider>().updateActivity(
                                ActivitiesModel(
                                    id: widget.activity.id,
                                    image: selectedImage?.path ?? '',
                                    tree: treeController.text,
                                    details: detailController.text,
                                    activity: activity,
                                    plot: plotSelected,
                                    date: date,
                                    executor: executorController.text,
                                    profileId: widget.activity.profileId));

                            Navigator.pop(context);
                          },
                          child: Text(
                            'ยืนยัน',
                            style: TextStyle(fontSize: 28.sp),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
