import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/models/activities_model.dart';
import 'package:myorchard/providers/activity_provider.dart';
import 'package:provider/provider.dart';

class ActivityDetail extends StatefulWidget {
  final ActivitiesModel activity;
  const ActivityDetail({super.key, required this.activity});

  @override
  State<ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  late double width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height * 0.36,
            child: Image.file(
              File(widget.activity.image!),
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
                              '${widget.activity.tree}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40.sp),
                            ),
                            Text(
                              '${widget.activity.date}',
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
                              Text('แปลง : ',
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                widget.activity.plot ?? '',
                                style: TextStyle(fontSize: 30.sp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: Row(
                            children: [
                              Text('กิจกรรม : ',
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                widget.activity.activity ?? '',
                                style: TextStyle(fontSize: 30.sp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width,
                          child: Row(
                            children: [
                              Text('รายละเอียด : ',
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                widget.activity.details ?? '',
                                style: TextStyle(fontSize: 30.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 185.w,
                            height: 70.h,
                            child: FilledButton(
                              onPressed: () {
                                context
                                    .read<ActivityProvider>()
                                    .removeActivity(widget.activity)
                                    .then((_) {
                                  Navigator.pop(context, true);
                                });
                              },
                              style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.redAccent)),
                              child: Text(
                                'ลบ',
                                style: TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 185.w,
                            height: 70.h,
                            child: FilledButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.green)),
                              child: Text(
                                'แก้ไข',
                                style: TextStyle(fontSize: 32),
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
          ),
          Positioned(
              top: 35,
              left: 10,
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                padding: EdgeInsets.only(left: 12.sp),
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 40.sp,
                    )),
              ))
        ],
      ),
    );
  }
}
