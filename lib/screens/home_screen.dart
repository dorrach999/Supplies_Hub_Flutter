import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:suplieshub/auth/auth.dart';
import 'package:suplieshub/auth/database.dart';
import 'package:suplieshub/models/data_test.dart';

import 'package:provider/provider.dart';
import 'package:suplieshub/screens/profile_screen.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  AuthSerives _serives = AuthSerives();
  final mail=FirebaseAuth.instance.currentUser?.email;

  void logOut(BuildContext context) async {
    await _serives.logOut();
  }

  void _showActionPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child:StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Supplies")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong!");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Text("No data Found");
            }
            if (snapshot != null && snapshot.data != null) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Call this number to reserve:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                snapshot.data!.docs[index]['phone'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(height: 5.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<TestData?>?>.value(
      value: DataBaseService().datas,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Home Screen',
            style: TextStyle(
              color: kPrimaryColor,
            ),
          ),
          centerTitle: true,
        ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Supplies")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong!");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Text("No data Found");
        }
        if (snapshot != null && snapshot.data != null) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data!.docs[index]['image'],
                            ),
                            fit: BoxFit.cover,
                          ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              snapshot.data!.docs[index]['name'],
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              snapshot.data!.docs[index]['description'],
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AUTHER: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              snapshot.data!.docs[index]['mail'],
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                   ),
                   color: Colors.white,
                  ),
                  child: MaterialButton(
                    onPressed: () =>_showActionPanel(context),
                    child: Text(
                      'Reserve',
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: orange,
                  ),
                ),
                ],
              ),
              );
            },
          );
        }
        return Container();
       },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                ),
                IconButton(
                  icon: Icon(Icons.all_inbox ),
                  onPressed: () => Navigator.pushNamed(context, '/posts'),
                ),
                IconButton(
                  icon: Icon(Icons.kayaking,
                    color: Colors.white,),
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                ),
                IconButton(
                  icon: Icon(Icons.account_circle_rounded),
                  onPressed: () => {
                    Get.to(()=> ProfileScreen()
                 ),
                },
                ),
                IconButton(
                  icon: Icon(Icons.logout_rounded),
                  onPressed: () => logOut(context),
                ),
            ],
          ),
        ),
     ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/addItem_screen'),
          backgroundColor: orange, // set the background color
          child: Icon(Icons.add),

        ),
      ),

    );
  }
}

