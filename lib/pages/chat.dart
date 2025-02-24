import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/models/chat_model.dart';
import 'package:myorchard/providers/chats_provider.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final int profileId;
  const Chat({super.key, required this.profileId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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

        title: Text(
          "บันทึก",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        toolbarHeight: 100.h,
      ),

      body: 
      Column(
        children: [
          ListView.builder(itemCount:context.watch<ChatsProvider>().listChats.length  ,itemBuilder:
          (context, index) {
            return Container(
              // width: 500.w,
              // height: 300.h,
              // decoration: BoxDecoration(
              //   color: Colors.blueAccent,
              //   borderRadius: BorderRadius.circular(10)
              // ),
            );
          },)
        ],
      ),
    );
  }
}
