// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable

import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  // final TextEditingController _stockController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uploading Data'),
          content: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void hideProgressDialog(VoidCallback hideCallback) {
    hideCallback();
  }

  PlatformFile? pickedFile;
  UploadTask? task;
  File? file;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.first;

    setState(() => pickedFile = path);
  }

  bool _isloading = false;

  Future uploadFood() async {
    setState(() {
      _isloading = true;
    });
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final fileMain = File(pickedFile!.path!);
    String postId = const Uuid().v1();
    final destination = 'foods/$postId';

    task = FirebaseApi.uploadFile(destination, fileMain);
    setState(() {});

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    try {
      await firestore.collection('foods').doc(postId).set({
        'postId': postId,
        'imageUrl': urlDownload,
        'food': _foodController.text,
        // 'stock': _stockController.text,
        'description': _descController.text,
        'price': int.parse(_priceController.text),
        'time': DateTime.now(),
        'rating': 0,
        'ratingCount': 0,
      });
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFA0A5BD), Color(0xFFB9B8C8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  (pickedFile == null)
                      ? GestureDetector(
                          onTap: selectFile,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.3,
                                width: width,
                                child: Image(
                                  image: AssetImage('assets/add_food.png'),
                                ),
                              ),
                              Text('Add item photo'),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: height * 0.53,
                          width: width,
                          child: Image.file(
                            fit: BoxFit.cover,
                            File(
                              pickedFile!.path!,
                            ),
                          ),
                        ),
                ],
              )),
          Positioned(
            top: height * 0.4,
            child: SizedBox(
              height: height * 0.5,
              width: width,
              child: Container(
                width: 180,
                height: 130,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color.fromARGB(255, 222, 221, 228),
                      Color.fromARGB(195, 230, 227, 230)
                    ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _foodController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Item Name',
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.025),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       shape: BoxShape.rectangle,
                    //       borderRadius: BorderRadius.circular(20),
                    //       color: Color.fromARGB(218, 241, 241, 241)),
                    //   width: width * 0.6,
                    //   height: height * 0.08,
                    //   child: Center(
                    //     child: Row(
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Container(
                    //             width: 40,
                    //             height: 40,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(20),
                    //               color: Color(0xFFfcf4e4),
                    //             ),
                    //             child: IconButton(
                    //               onPressed: () {},
                    //               icon: Icon(
                    //                 Icons.shopping_bag_outlined,
                    //                 size: 16,
                    //               ),
                    //               color: Color(0xFF756d54),
                    //             ),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.all(2.0),
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               SizedBox(
                    //                 height: 45,
                    //                 width: 150,
                    //                 child: TextField(
                    //                   controller: _stockController,
                    //                   decoration: InputDecoration(
                    //                     hintText: 'Stocks (optional)',
                    //                     border: InputBorder.none,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _descController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Item Description',
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.015),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(218, 241, 241, 241)),
                      width: width * 0.6,
                      height: height * 0.08,
                      child: Center(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFFfcf4e4),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.attach_money_outlined,
                                    size: 16,
                                  ),
                                  color: Color(0xFF756d54),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 45,
                                    width: 150,
                                    child: TextField(
                                      controller: _priceController,
                                      decoration: InputDecoration(
                                        hintText: 'Price',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: width * 0.6,
                      height: width * 0.15,
                      child: GestureDetector(
                        onTap: () async {
                          await uploadFood();
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Yay',
                              message: 'Item Added',
                              contentType: ContentType.success,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: _isloading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Add Item',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
