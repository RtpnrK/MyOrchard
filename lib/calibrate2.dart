import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Calibrate2 extends StatefulWidget {
  const Calibrate2({super.key});

  @override
  State<Calibrate2> createState() => _Calibrate2State();
}

class _Calibrate2State extends State<Calibrate2> {
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
            'ปรับเทียบ',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: TextButton.icon(
                onPressed: (){},
                label: Text('บันทึก'),
                icon: Icon(Icons.save, size: 30.sp,),
                iconAlignment: IconAlignment.end,),
            )
          ],
          toolbarHeight: 100.h,
    ));
  }
}