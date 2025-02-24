import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    context.read<ChatsProvider>().loadChats(widget.profileId);
    super.initState();
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
        title: Text(
          "บันทึก",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        toolbarHeight: 100.h,
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 10.w, bottom: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: context.watch<ChatsProvider>().listChats.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {
                        
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 320.w),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4.h, bottom: 4.h, left: 8.w, right: 8.w),
                              child: Text(
                                context
                                    .watch<ChatsProvider>()
                                    .listChats[index]
                                    .message,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 368.w,
              child: TextField(
                controller: _messageController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "ข้อความ...",
                  hintStyle: TextStyle(),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt,
                        size: 32.sp,
                      )),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      context.read<ChatsProvider>().addChat(ChatModel(
                            message: _messageController.text,
                            time: DateFormat.Hms().format(DateTime.now()),
                            date: DateFormat.yMd().format(DateTime.now()),
                            profileId: widget.profileId,
                          ));
                      setState(() {
                        _messageController.clear();
                      });
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
