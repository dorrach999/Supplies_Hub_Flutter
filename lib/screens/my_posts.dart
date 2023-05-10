import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suplieshub/auth/auth.dart';
import 'package:suplieshub/auth/database.dart';
import 'package:suplieshub/models/data_test.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:suplieshub/screens/profile_screen.dart';

import '../constants.dart';
import 'edit_post.dart';

class MyPostsScreen extends StatefulWidget {

  @override
  _MyPostsScreenState createState() => _MyPostsScreenState();

}

class _MyPostsScreenState extends State<MyPostsScreen> {
  AuthSerives _serives = AuthSerives();
  User? userId=FirebaseAuth.instance.currentUser;

  void logOut(BuildContext context) async {
    await _serives.logOut();
  }

  void _showActionPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
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
              .where("mail", isEqualTo: userId?.email)
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
              return ListView.builder(
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
                        Container(
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
                          height: 200,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.docs[index]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                snapshot.data!.docs[index]['description'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
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
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => EditPost(),
                          arguments: {
                            'name': snapshot.data!.docs[index]['name'],
                            'desc': snapshot.data!.docs[index]['description'],
                            'postId': snapshot.data!.docs[index].id,
                          },
                        );
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: orange,
                        onPrimary: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Perform the CRUD operation for "delete"
                        await FirebaseFirestore.instance
                            .collection('Supplies')
                            .doc(snapshot.data?.docs[index].id)
                            .delete();
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        onPrimary: Colors.white,
                      ),
                    ),
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
          backgroundColor: orange,
          child: Icon(Icons.add),

        ),
      ),
    );
  }
}

