import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myorchard/calibrate.dart';
import 'package:myorchard/home.dart';

class PickerButt extends StatefulWidget {
  const PickerButt({super.key});

  @override
  State<PickerButt> createState() => _PickerButtState();
}

class _PickerButtState extends State<PickerButt> {
  File? imagFile;
  final picker = ImagePicker();
  final _textEditController = TextEditingController();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new map"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
              const Text('Map Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  pickImage();
                },
                child: Container(
                  height: 350,
                  width: 350,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: imagFile != null
                      ? Image.file(imagFile!)
                      : const Icon(
                          Icons.upload,
                          size: 100,
                          color: Colors.black38,
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                height: 70,
                child: TextField(
                  controller: _textEditController,
                  maxLength: 30,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter map name',
                      border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: const Text('Cancel'),
                    icon: const Icon(Icons.cancel),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(img: imagFile, title: _textEditController.text,)),
                      );
                    },
                    label: const Text('Create'),
                    icon: const Icon(Icons.create),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
