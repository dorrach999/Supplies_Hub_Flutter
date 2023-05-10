import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suplieshub/auth/auth.dart';
import 'package:suplieshub/screens/screen.dart';
import 'package:suplieshub/widgets/widget.dart';

import '../constants.dart';

class Register extends StatefulWidget {
  Register({
    Key? key,
    required this.formKeys,
    required this.textControllers,
    required this.nodes,
  }) : super(key: key);

  final GlobalKey<FormState> formKeys;
  final List<TextEditingController> textControllers;
  final List<FocusNode> nodes;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController controllerName=TextEditingController();
  TextEditingController controllerTel=TextEditingController();
  User? userId=FirebaseAuth.instance.currentUser;
  AuthSerives _serives = AuthSerives();

  String? mail;

  String? password;

  void logIn(BuildContext context) async {
    final check = widget.formKeys.currentState!.validate();

    mail = widget.textControllers[0].text;
    password = widget.textControllers[1].text;
    if (mail!.isNotEmpty && password!.isNotEmpty) {
      await _serives.registerMailPasword(mail, password);
    } else if (mail!.isNotEmpty && password!.isEmpty) {
      FocusScope.of(context).requestFocus(widget.nodes[1]);
    }
  }

  void back(BuildContext context) {
    WelcomeScreen.of(context).onBack();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Register',
          style: TextStyle(
          color: kPrimaryColor,
        ),),
        leading: IconButton(
          onPressed: () => back(context),
          icon: Icon(Icons.arrow_back_ios),
          color: kPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              child: SvgPicture.asset(
                "assets/icons/signup.svg",
              ),
            ),
        Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.0),
        child:TextFormField(
          controller: controllerName,
          autofocus: true,
          validator: (input) {
            if (input!.isEmpty) {
              return 'cant be null';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: Icon(Icons.account_circle_rounded, color: orange),
          ),
        ),
        ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: TextFormField(
                controller: controllerTel,
                autofocus: true,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'cant be null';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.phone, color: orange),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            InputWidget(
              formKey: widget.formKeys,
              editController: widget.textControllers,
              itemCount: widget.textControllers.length,
              nodes: widget.nodes,
              icons: [
                Icons.mail,
                Icons.lock,
              ],
              type: [
                TextInputType.emailAddress,
                TextInputType.visiblePassword,
              ],
              titles: [
                'e-mail',
                'password',
              ],
            ),
            SizedBox(height: 5.0),
            SizedBox(
              width: size.width * .8,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: orange,
                textColor: Colors.white,
                child: Text('Register'),
                onPressed: () async {
                  logIn(context);
                  Map<String, String> dataToSave = {
                    'name': controllerName.text,
                    'tel': controllerTel.text,
                    'mail': mail!.toString(),

                  };
                  //Add the data to the database
                  await FirebaseFirestore.instance.collection('Users').add(
                      dataToSave);
                },
              ),
            ),
          ],
        ),
       ),

    );
  }
}
