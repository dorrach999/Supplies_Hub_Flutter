import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key : key);

  @override
  State<AddItem> createState()=> _AddItemState();
}

class _AddItemState extends State<AddItem>{
  TextEditingController _controllerName=TextEditingController();
  TextEditingController _controllerDesc=TextEditingController();
  final  mail=FirebaseAuth.instance.currentUser;
  String imageUrl = '';

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: orange,
          title: Text('Add Item'),
        centerTitle: true,
    ),
        body: Column(
          children: [
            SizedBox(height: 16.0),
            TextField(
              controller: _controllerName,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _controllerDesc,
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
                  referenceDirImages;

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
                Navigator.pushNamed(context, '/home');
                if (imageUrl.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Please upload an image')));
                  return;
                }

                String generateRandomPhoneNumber() {
                  var rng = new Random();
                  String number;
                  do {
                    number = rng.nextInt(99999999).toString().padLeft(8, '0');
                  } while (!['9', '2'].contains(number[0]));
                  return number;
                }
                //Create a Map with the input data
                Map<String,String> dataToSave={
                  'name':_controllerName.text,
                  'description':_controllerDesc.text,
                  'mail': mail!.email!,
                  'phone': generateRandomPhoneNumber(),
                  'image': imageUrl,
                };
                //Add the data to the database
                await FirebaseFirestore.instance.collection('Supplies').add(dataToSave);

              },

              child: Text('Add Item'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(orange), // sets background color to blue
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // sets text color to white
              ),
            ),
      ],
    )
    );
  }
}