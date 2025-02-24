import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/custom_icons/customIcons.dart';
import 'package:myorchard/pages/edit_profile.dart';

class Profile extends StatefulWidget {
  final File image;
  final String name;
  final List? plots;
  final int idMap;
  const Profile(
      {super.key,
      required this.image,
      required this.name,
      this.plots,
      required this.idMap});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Center(
          child: Column(
            children: [
              Card(
                child: Container(
                  height: 300.h,
                  width: 380.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(22.5)),
                      image: DecorationImage(
                          image: FileImage(widget.image), fit: BoxFit.cover)),
                ),
              ),
              Spacer(),
              Card(
                  child: Container(
                width: 380.w,
                height: 365.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(22.5),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 25.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "ชื่อ : ",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          widget.name.isEmpty
                              ? Text("ไม่ได้ใส่ข้อมูล")
                              : Text(
                                  widget.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "แปลง : ",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 235.h,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.plots!.length,
                                  itemBuilder: (context, index) {
                                    return Text(widget.plots![index]);
                                  }),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      );
  }
}
