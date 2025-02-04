import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/custom_icons/customIcons.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(top: 12.h),
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
        title:
            Text('กิจกรรม', style: Theme.of(context).textTheme.headlineLarge),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: IconButton(
              icon: Icon(
                CustomIcons.export_2,
                size: 32.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h, right: 10.w),
            child: IconButton(
              icon: Icon(
                CustomIcons.chat_1,
                size: 32.sp,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {},
            ),
          ),
        ],
        centerTitle: true,
        toolbarHeight: 100.h,
      ),
      body: Column(
        children: [

        ],
      )
    );
  }
}
