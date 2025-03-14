import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/models/activities_model.dart';
import 'package:myorchard/pages/edit_activity.dart';
import 'package:myorchard/providers/activity_provider.dart';
import 'package:provider/provider.dart';

class ActivityDetail extends StatefulWidget {
  final ActivitiesModel activity;
  final List? plots;
  const ActivityDetail({
    super.key,
    required this.activity,
    this.plots,
  });

  @override
  State<ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  late double width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    final activityProvider = context.watch<ActivityProvider>();
    final updatedActivity = activityProvider.listActivities.firstWhere(
      (a) => a.id == widget.activity.id,
      orElse: () => widget.activity,
    );

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height * 0.36,
            child: widget.activity.image!.isNotEmpty ? Image.file(
              File(widget.activity.image!),
              fit: BoxFit.cover,
            ) : Image.asset(
              'assets/images/no_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.32),
            child: Container(
              width: width,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  border: Border.all(color: Colors.black26),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, -3))
                  ]),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${updatedActivity.tree}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40.sp),
                            ),
                            Text(
                              '${updatedActivity.date}',
                              style: TextStyle(
                                  color: Color.fromRGBO(66, 65, 65, 1),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30.sp),
                            )
                          ],
                        ),
                        SizedBox(
                          width: width,
                          child: Row(
                            children: [
                              Text('แปลง : ${updatedActivity.plot}',
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                    'กิจกรรม : ${updatedActivity.activity} ',
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                    'ผู้ปฏิบัติการ : ${updatedActivity.executor} ',
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                    'รายละเอียด : ${updatedActivity.details} ',
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 185.w,
                            height: 70.h,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'ย้อนกลับ',
                                style: TextStyle(fontSize: 28.sp),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 185.w,
                            height: 70.h,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditActivity(
                                              activity: updatedActivity,
                                              plots: widget.plots,
                                            )));
                              },
                              child: Text(
                                'แก้ไข',
                                style: TextStyle(fontSize: 28.sp),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
