import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:suplieshub/auth/auth.dart';
import 'package:suplieshub/controller.dart';

import 'package:provider/provider.dart';
import 'package:suplieshub/screens/addItem_screen.dart';
import 'package:suplieshub/screens/home_screen.dart';
import 'package:suplieshub/screens/my_posts.dart';

import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Users?>.value(
          value: AuthSerives().user,
          initialData: null,
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/addItem_screen': (context) => AddItem(),
          '/home': (context) => HomeScreen(),
          '/posts': (context) => MyPostsScreen(),
        },
        title: 'Flutter Firebase Log In and Sign In Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Controller(),
      ),
    );
  }
}
