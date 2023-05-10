import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class EditPost extends StatefulWidget {
  const EditPost({Key? key}) : super(key : key);

  @override
  State<EditPost> createState()=> _EditPostState();
}

class _EditPostState extends State<EditPost>{
  TextEditingController controllerName=TextEditingController();
  TextEditingController controllerDesc=TextEditingController();
  User? userId=FirebaseAuth.instance.currentUser;
  String imageUrl = '';

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: orange,
          title: Text('Profile',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),

        body: Column(
          children: [
            SizedBox(height: 16.0),
            TextField(
              controller: controllerName..
              text="${Get.arguments['name']?.toString()}",
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controllerDesc..
              text="${Get.arguments['desc']?.toString()}",
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16.0),
            IconButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                  await imagePicker.pickImage(source: ImageSource.gallery);
                  print('${file?.path}');

                  if (file == null) return;
                  //Import dart:core
                  String uniqueFileName =
                  DateTime.now().millisecondsSinceEpoch.toString();

                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages =
                  referenceRoot.child('images');

                  //Create a reference for the image to be stored
                  Reference referenceImageToUpload =
                  referenceDirImages.child('name');

                  //Handle errors/success
                  try {
                    //Store the file
                    await referenceImageToUpload.putFile(File(file.path));
                    //Success: get the download URL
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                  } catch (error) {
                    //Some error occurred
                  }
                },
                icon: Icon(Icons.add_photo_alternate_rounded)),
            ElevatedButton(
              onPressed: () async {
                //Create a Map with the input data
                print(Get.arguments?['postId']);
                //Add the data to the database
                await FirebaseFirestore.instance
                    .collection('Supplies')
                    .doc((Get.arguments?['postId']))
                    .update({
                  'name':controllerName.text,
                  'description':controllerDesc.text,
                  'image': imageUrl,
                }).then((value) => {
                  //print("Data Updated"),
                  Navigator.pushNamed(context, '/posts'),
                  print("Data Updated"),
                });
              },
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor , // set the background color of the button
              ),
              child: Text('Update'),
            ),
          ],
        )
    );
  }
}