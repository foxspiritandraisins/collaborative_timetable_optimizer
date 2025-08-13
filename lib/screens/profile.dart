import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_timetable_optimizer/components/menubarDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  static String id = "profile";

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late String firstname, lastname, email;

  @override
  void initState() {
    String uid = _auth.currentUser!.uid;
    // DocumentSnapshot documentSnapshot = db.collection('users').doc(uid);
    // documentSnapshot.get().then();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      drawer: menubardrawer(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Text("Firstname: "),
                // TextField(enabled: false,)
              ],
            ),
            Row(
              children: [
                Text("Last name: "),
                // TextField(enabled: false,)
              ],
            ),
            Row(
              children: [
                Text("email: "),
                SizedBox(width: 170,
                    child: TextField(enabled: true,))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

