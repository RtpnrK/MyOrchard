import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return SizedBox(
      height: 680.h,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10.h,
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
                Card(
                    child: Container(
                  width: 380.w,
                  height: 320.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(22.5),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 25.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "ชื่อ : ",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              widget.name.isEmpty
                                  ? Text("ไม่ได้ใส่ข้อมูล", style: Theme.of(context).textTheme.bodyLarge,)
                                  : Text(
                                      widget.name,
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    )
                            ],
                          ),
                          Text(
                            "แปลง : ",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          ...List.generate(widget.plots!.length, (index){
                                return Padding(
                                  padding: EdgeInsets.only(left: 30.w),
                                  child: Text('- ${widget.plots![index]}', style: Theme.of(context).textTheme.bodyLarge,),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
