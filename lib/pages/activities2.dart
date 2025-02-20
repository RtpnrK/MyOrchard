import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/models/activities_model.dart';
import 'package:myorchard/pages/activityDetail.dart';
import 'package:myorchard/pages/create_activity.dart';
import 'package:myorchard/providers/activity_provider.dart';
import 'package:provider/provider.dart';

class Activities2 extends StatefulWidget {
  final int idMap;
  final List? plots;
  const Activities2({super.key, required this.plots, required this.idMap});

  @override
  State<Activities2> createState() => _Activities2State();
}

class _Activities2State extends State<Activities2> {
  @override
  void initState() {
    context.read<ActivityProvider>().loadActivities(widget.idMap);
    super.initState();
  }

  Widget buildCard(BuildContext context, String tree, activity, image,
      ActivitiesModel activityD) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => ActivityProvider(widget.idMap),
                ),
              ],
              child: ActivityDetail(
                activity: activityD,
              ),
            );
          })).then((value) {
            if (value == true) {
              context.read<ActivityProvider>().loadActivities(widget.idMap);
            }
          });
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
                      borderRadius: BorderRadius.circular(18.sp),
                      image: DecorationImage(
                          image: FileImage(File(image)), fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // จัดเนื้อหาชิดซ้าย
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("ต้น : $tree ",
                          style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(
                        width: 200.w,
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Text(
                        "กิจกรรม :$activity ",
                        style: Theme.of(context).textTheme.bodySmall,
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
          "กิจกรรม",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 12.h, right: 10.w),
            child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/icons/upload.png'),
                size: 32.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.h, right: 10.w),
            child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/icons/messenger.png'),
                size: 32.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {},
            ),
          ),
        ],
        toolbarHeight: 100.h,
      ),
      body: Padding(
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
                      var activity = context
                          .watch<ActivityProvider>()
                          .listActivities[index];
                      return buildCard(context, activity.tree!,
                          activity.activity, activity.image, activity);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => ActivityProvider(widget.idMap),
                ),
              ],
              child: CreateActivity(
                idMap: widget.idMap,
                plots: widget.plots,
              ),
            );
          })).then((value) {
            if (value == true) {
              context.read<ActivityProvider>().loadActivities(widget.idMap);
            }
          });
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
