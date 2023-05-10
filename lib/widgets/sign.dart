import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suplieshub/auth/auth.dart';
import 'package:suplieshub/screens/welcome_screen.dart';
import '../constants.dart';
import 'widget.dart';

class SignIn extends StatefulWidget {
  SignIn({
    Key? key,
    required this.formKeys,
    required this.textControllers,
    required this.nodes,
  }) : super(key: key);

  final GlobalKey<FormState> formKeys;
  final List<TextEditingController> textControllers;
  final List<FocusNode> nodes;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthSerives _serives = AuthSerives();

  String? mail;

  String? password;

  void signIn(BuildContext context) async {
    widget.formKeys.currentState!.validate();

    mail = widget.textControllers[0].text;
    password = widget.textControllers[1].text;

    if (mail!.isNotEmpty && password!.isNotEmpty) {
      setState(() {
        isLoad = false;
      });
      dynamic user = await _serives.signMailPassword(mail, password);
      setState(() {
        isLoad = true;
      });
      if (user == null) {
        print('failed');
      } else {
        print('successful signing');
      }
    } else if (mail!.isNotEmpty && password!.isEmpty) {
      FocusScope.of(context).requestFocus(widget.nodes[1]);
    }
  }

  void logIn(BuildContext context) async {
    WelcomeScreen.of(context).jumpLogin();
  }

  bool isLoad = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Login',
          style: TextStyle(
            color: orange,
          ),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
          width: 250,
          height: 250,
          child: SvgPicture.asset(
            "assets/icons/login.svg",
          ),
        ),
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
            SizedBox(
              width: size.width * .8,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: kPrimaryColor,
                textColor: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0.0,
                      child: !isLoad
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator())
                          : SizedBox.shrink(),
                    ),
                    Center(child: Text('Sign In')),
                  ],
                ),
                onPressed: () => signIn(context),
              ),
            ),
            Text('or'),
            SizedBox(
              width: size.width * .6,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Colors.orange,
                textColor: Colors.white,
                child: Text('Register'),
                onPressed: () => logIn(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
