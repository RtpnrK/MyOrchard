import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/models/activities_model.dart';
import 'package:myorchard/pages/activityDetail.dart';
import 'package:myorchard/providers/activity_provider.dart';
import 'package:provider/provider.dart';

class Activities extends StatefulWidget {
  final int idMap;
  final List? plots;
  const Activities({super.key, required this.plots, required this.idMap});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  void initState() {
    context.read<ActivityProvider>().loadActivities(widget.idMap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Column(
                  children: List.generate(
                    context.watch<ActivityProvider>().listActivities.length,
                    (index) {
                      ActivitiesModel activity = context
                          .watch<ActivityProvider>()
                          .listActivities[index];
                      return Card(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ActivityDetail(
                                activity: activity,
                                plots: widget.plots,
                              );
                            }));
                          },
                          child: SizedBox(
                            height: 138.h,
                            width: 395.w,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 150.w,
                                    height: 110.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.sp),
                                        image: DecorationImage(
                                            onError: (exception, stackTrace) =>
                                                () {
                                                  print(exception);
                                                  setState(() {
                                                    activity.image = null
                                                       ;
                                                  });
                                                },
                                            image: FileImage(
                                                File(activity.image!)),
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // จัดเนื้อหาชิดซ้าย
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("ต้น : ${activity.tree} ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                        SizedBox(
                                          width: 200.w,
                                          child: Divider(
                                            thickness: 2,
                                          ),
                                        ),
                                        Text(
                                          "กิจกรรม :${activity.activity} ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
  //     ,
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         Navigator.push(context, MaterialPageRoute(builder: (context) {
  //           return CreateActivity(
  //             idMap: widget.idMap,
  //             plots: widget.plots,
  //           );
  //         }));
  //       },
  //       backgroundColor: Theme.of(context).colorScheme.secondary,
  //       child: Icon(Icons.add),
  //     ),
  //     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  //   );
  // }
}
}