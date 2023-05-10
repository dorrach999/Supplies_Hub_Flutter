import 'package:flutter/material.dart';
import 'package:suplieshub/models/user_model.dart';
import 'package:suplieshub/screens/screen.dart';
import 'package:provider/provider.dart';

class Controller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    return user != null ? HomeScreen() : WelcomeScreen();
  }
}
