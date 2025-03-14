import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myorchard/models/chat_model.dart';
import 'package:myorchard/pickImage.dart';
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
  ScrollController _scrollController = ScrollController();
  bool _isMessageEmpty = true;
  bool _isFile = false;
  File? selectedImage;
  void _onTextChanged() {
    setState(() {
      _isMessageEmpty = _messageController.text.isEmpty;
    });
  }

  bool isFile(String message) {
    _isFile = File(message).existsSync();
    return _isFile;
  }

  Future<void> selectImageGallery() async {
    final image = await pickImage(ImageSource.gallery); // Call the function
    setState(() {
      selectedImage = image; // Update the state with the picked image
    });
  }

  Future<void> selectImageCamera() async {
    final image = await pickImage(ImageSource.camera); // Call the function
    setState(() {
      selectedImage = image; // Update the state with the picked image
    });
  }

  void showOption() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 180.h,
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'เลือกรูปจาก',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                Divider(),
                InkWell(
                    onTap: () {
                      selectImageGallery();
                      Navigator.pop(context);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8.w,
                        children: [
                          Text(
                            "เลือกรูปจากแกลเลอรี่",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                          ),
                          Icon(
                            Icons.photo_size_select_actual_rounded,
                            size: 24.sp,
                            color: Colors.grey,
                          )
                        ])),
                Divider(),
                InkWell(
                  onTap: () {
                    selectImageCamera();
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.w,
                    children: [
                      Text(
                        "ถ่ายภาพ",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                      Icon(
                        Icons.camera_alt,
                        size: 24.sp,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    context.read<ChatsProvider>().loadChats(widget.profileId);
    _messageController.addListener(_onTextChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('ลบทั้งหมด'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext) {
                        return AlertDialog(
                          title: Text(
                            'ยืนยันการลบบันทึก',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 30.sp),
                          ),
                          content: Text(
                            'คุณต้องการลบบันทึกทั้งหมดใช่หรือไม่?',
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
                                  for (var c in context
                                      .read<ChatsProvider>()
                                      .listChats) {
                                    context.read<ChatsProvider>().removeChat(c);
                                  }
                                  Navigator.pop(context);
                                },
                                child: Text('ยืนยัน'))
                          ],
                        );
                      });
                },
              )
            ],
            iconSize: 40.sp,
            iconColor: Theme.of(context).colorScheme.secondary,
          )
        ],
        toolbarHeight: 100.h,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.w, bottom: 10.h, top: 10.h),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    context.watch<ChatsProvider>().listChats.length,
                    (index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Text(
                                      '${context.watch<ChatsProvider>().listChats[index].time.substring(0, 5)} น.',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                  isFile(context
                                              .watch<ChatsProvider>()
                                              .listChats[index]
                                              .message) ==
                                          false
                                      ? InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                          onLongPress: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                      width: double.infinity,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                context
                                                                    .read<
                                                                        ChatsProvider>()
                                                                    .removeChat(context
                                                                        .read<
                                                                            ChatsProvider>()
                                                                        .listChats[index]);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "ยกเลิกข้อความ",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                              ),
                                                            ),
                                                          ]));
                                                });
                                          },
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.w),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 4.h,
                                                    bottom: 4.h,
                                                    left: 8.w,
                                                    right: 8.w),
                                                child: Text(
                                                  context
                                                      .watch<ChatsProvider>()
                                                      .listChats[index]
                                                      .message,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary),
                                                )),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => Scaffold(
                                                      backgroundColor:
                                                          Colors.black,
                                                      appBar: AppBar(
                                                        backgroundColor:
                                                            Colors.black,
                                                        leading: IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            size: 40.sp,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                      body: Center(
                                                        child: InteractiveViewer(
                                                            child: SizedBox(
                                                                height: double
                                                                    .infinity,
                                                                width: double
                                                                    .infinity,
                                                                child: Image.file(File(context
                                                                    .watch<
                                                                        ChatsProvider>()
                                                                    .listChats[
                                                                        index]
                                                                    .message)))),
                                                      ),
                                                    ));
                                          },
                                          onLongPress: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                      width: double.infinity,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                context
                                                                    .read<
                                                                        ChatsProvider>()
                                                                    .removeChat(context
                                                                        .read<
                                                                            ChatsProvider>()
                                                                        .listChats[index]);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "ยกเลิกข้อความ",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                              ),
                                                            ),
                                                          ]));
                                                });
                                          },
                                          child: Ink(
                                            height: 280.h,
                                            width: 280.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(File(
                                                        context
                                                            .watch<
                                                                ChatsProvider>()
                                                            .listChats[index]
                                                            .message)))),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          if (context
                                      .watch<ChatsProvider>()
                                      .listChats[index]
                                      .date !=
                                  DateFormat.yMd().format(DateTime.now()) &&
                              (index !=
                                  context
                                          .watch<ChatsProvider>()
                                          .listChats
                                          .length -
                                      1) &&
                              context
                                      .watch<ChatsProvider>()
                                      .listChats[index]
                                      .date !=
                                  context
                                      .watch<ChatsProvider>()
                                      .listChats[index + 1]
                                      .date)
                            SizedBox(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 10.w,
                                    children: [
                                  SizedBox(
                                    width: 130.w,
                                    child: Divider(
                                      thickness: 2,
                                    ),
                                  ),
                                  Text(
                                    context
                                        .watch<ChatsProvider>()
                                        .listChats[index]
                                        .date,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  SizedBox(
                                    width: 130.w,
                                    child: Divider(
                                      thickness: 2,
                                    ),
                                  ),
                                ])),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 180.h),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: ScreenUtil().scaleHeight < 1 ? 4.h : 0),
                  child: IconButton(
                    icon: _isMessageEmpty
                        ? Icon(
                            Icons.camera_alt,
                            size: 32.sp,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : Icon(
                            Icons.arrow_back_ios,
                            size: 32.sp,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    onPressed: _isMessageEmpty
                        ? () {
                            showOption();
                          }
                        : () {
                            _messageController.clear();
                          },
                  ),
                ),
                selectedImage == null
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: SizedBox(
                          width: 300.w,
                          child: TextField(
                            controller: _messageController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: Colors.black),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "ข้อความ...",
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Stack(children: [
                        Card(
                          elevation: 3,
                          child: Container(
                              constraints: BoxConstraints(
                                  maxHeight: 160.h, maxWidth: 180.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.sp),
                                child: Image.file(
                                  selectedImage!,
                                ),
                              )),
                        ),
                        Positioned(
                            top: 4,
                            right: 4,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedImage = null;
                                  });
                                },
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 24.sp,
                                )))
                      ]),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: ScreenUtil().scaleHeight < 1 ? 6.h : 0),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                      size: 34.sp,
                    ),
                    onPressed: (_messageController.text.isNotEmpty ||
                            selectedImage != null)
                        ? () {
                            print("image : ${selectedImage} ");
                            context.read<ChatsProvider>().addChat(ChatModel(
                                  message: selectedImage == null
                                      ? _messageController.text
                                      : selectedImage!.path,
                                  time: DateFormat.Hms().format(DateTime.now()),
                                  date: DateFormat.yMd().format(DateTime.now()),
                                  profileId: widget.profileId,
                                ));
                            setState(() {
                              _messageController.clear();
                              selectedImage = null;
                              double bottom =
                                  _scrollController.position.maxScrollExtent;
                              _scrollController.jumpTo(bottom);
                            });
                          }
                        : () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
