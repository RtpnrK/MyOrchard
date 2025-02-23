import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/pages/activityDetail.dart';
import 'package:myorchard/pages/create_activity.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  Widget buildCard(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ActivityDetail();
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
                      borderRadius: BorderRadius.circular(18.sp),
                      image: DecorationImage(
                          image: AssetImage('assets/images/tree.jpg'),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // จัดเนื้อหาชิดซ้าย
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("ต้น : ",
                        style: Theme.of(context).textTheme.bodySmall),
                    SizedBox(
                      width: 200.w,
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Text("กิจกรรม : ",
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
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
    return  Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 25.h, 0, 25.h),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildCard(context),
            ],
          ),
        ),
      );
  }
}
