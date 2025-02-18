import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/pages/activityDetail.dart';
import 'package:myorchard/pages/create_activity.dart';

class Activities2 extends StatefulWidget {
  const Activities2({super.key});

  @override
  State<Activities2> createState() => _Activities2State();
}

class _Activities2State extends State<Activities2> {
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
              onPressed: () {
                
              },
            ),
          ),
        ],
        toolbarHeight: 100.h,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 25.h, 0, 25.h),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildCard(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CreateActivity();
                }));
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
