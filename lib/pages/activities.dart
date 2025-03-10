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
  bool editMode = false;
  bool selectAll = false;

  @override
  void initState() {
    context.read<ActivityProvider>().loadActivities(widget.idMap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ActivitiesModel> activityList =
        Provider.of<ActivityProvider>(context, listen: false).listActivities;
    if (activityList.any((activity) => activity.isSelected)){
      setState(() {
        editMode = true;
      });
    } else {
      setState(() {
        editMode = false;
      });
    }
    return Scaffold(
      appBar: editMode
          ? AppBar(
              backgroundColor: Colors.transparent,
              scrolledUnderElevation: 0,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      editMode = false;
                      for (var a in activityList) {
                        a.isSelected = false;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 36.sp,
                  )),
              automaticallyImplyLeading: false,
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectAll = !selectAll;
                      for (var a in activityList) {
                        if (selectAll) {
                          a.isSelected = true;
                        } else {
                          a.isSelected = false;
                        }
                      }
                    });
                  },
                  child: Text('เลือกทั้งหมด', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext) {
                          return AlertDialog(
                            title: Text(
                              'ยืนยันการลบกิจกรรม',
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 30.sp),
                            ),
                            content: Text(
                              'คุณต้องการลบกิจกรรมนี้ใช่หรือไม่?',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('ยกเลิก')),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      for (var a in activityList) {
                                      if (a.isSelected) {
                                        context
                                        .read<ActivityProvider>()
                                        .removeActivity(a);
                                      }
                                    }
                                    });
                                    
                                    Navigator.pop(context);
                                    // context
                                    //     .read<ActivityProvider>()
                                    //     .removeActivity(updatedActivity);
                                    // Navigator.pop(context);
                                    // Navigator.pop(context, true);
                                  },
                                  child: Text('ยืนยัน'))
                            ],
                          );
                        });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 36.sp,
                  ),
                )
              ],
            )
          : null,
      body: Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 80.h),
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
                          borderRadius: BorderRadius.circular(22.5),
                          onLongPress: () {
                            setState(() {
                              editMode = true;
                              activity.isSelected = true;
                            });
                          },
                          onTap: editMode
                              ? () {
                                  setState(() {
                                    activity.isSelected =
                                        !(activity.isSelected);
                                  });
                                }
                              : () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ActivityDetail(
                                      activity: activity,
                                      plots: widget.plots,
                                    );
                                  }));
                                },
                          child: Container(
                            height: 138.h,
                            width: 395.w,
                            decoration: (editMode && activity.isSelected)
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(22.5),
                                    border: Border.all(
                                        color: Colors.blueAccent, width: 4))
                                : null,
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
                                                    activity.image = null;
                                                  });
                                                },
                                            image: activity.image!.isNotEmpty
                                                ? FileImage(
                                                    File(activity.image!))
                                                : AssetImage(
                                                    'assets/images/no_image.jpg'),
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
                                        Text("ชื่อ : ${activity.tree} ",
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
                                          "กิจกรรม : ${activity.activity} ",
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
      ),
    );
  }
}
