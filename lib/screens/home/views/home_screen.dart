import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> selectedImages = [];
  final picker = ImagePicker();

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          // CupertinoActionSheetAction(
          //   child: Text('Camera'),
          //   onPressed: () {
          //     // close the options modal
          //     Navigator.of(context).pop();
          //     // get image from camera
          //     // getImageFromCamera();
          //   },
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Commercial Offer'),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              selectedImages.isEmpty
                  ? GestureDetector(
                      onTap: showOptions,
                      child: Container(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.add_a_photo),
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: FileImage(selectedImages[0]),
                              fit: BoxFit.cover)),
                    ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.width / 2,
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      return selectedImages.length - 1 > index
                          ? Container(
                              height: MediaQuery.of(context).size.width / 2,
                              width: MediaQuery.of(context).size.width / 2,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: FileImage(selectedImages[index + 1]),
                                      fit: BoxFit.cover)),
                            )
                          : GestureDetector(
                              onTap: showOptions,
                              child: Container(
                                height: MediaQuery.of(context).size.width / 2,
                                width: MediaQuery.of(context).size.width / 2,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(Icons.add_a_photo),
                              ),
                            );
                    }),
              ),
            ],
          )),
    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
