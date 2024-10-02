import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorchard/calibrate.dart';

class PickerButt extends StatefulWidget {
  const PickerButt({super.key});

  @override
  State<PickerButt> createState() => _PickerButtState();
}

class _PickerButtState extends State<PickerButt> {
  File? imagFile;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagFile = File(pickedFile.path);
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Calibrate(
                image: imagFile,
              )),
    );
    print(imagFile);
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text("แผนที่"),
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              // height: 400,
              // width: 400,
              child: imagFile != null
                  ? Image.file(imagFile!)
                  : const Text(
                      "กรุณาเพิ่มรูป",
                      style: TextStyle(fontSize: 50),
                    ),
            ),
          ),
          Center(
              child: ElevatedButton(
            onPressed: () {
              pickImage();
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(25))),
            child: const Text(
              "เลือกรูป",
              style: TextStyle(fontSize: 40),
            ),
          )),
        ],
      ),
    );
  }
}
