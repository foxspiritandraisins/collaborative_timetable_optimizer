import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_timetable_optimizer/components/menubarDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class editTimetable extends StatefulWidget {
  static String id ='editTimetable';

  @override
  State<editTimetable> createState() => _editTimetableState();
}

class _editTimetableState extends State<editTimetable> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late final String? receivedData;

  @override
  void initState() {
    super.initState();
    _getThisTimetableData();
    //2 status to this file, create>import(ignored) or added, tap from dashboard
    //read from sharedTimetable, check if joined id got owner, !exist> joinedUser++,
  }
  Future<void> _getThisTimetableData() async {

  }

  @override
  Widget build(BuildContext context) {
    // receivedData = ModalRoute.of(context)?.settings.arguments.toString();
    // DocumentSnapshot docSnap = await db.collection('ownedTimetable').doc(receivedData).get();
    return Scaffold(
      appBar: AppBar(
        title: Text("zzz"),
      ),
      drawer: menubardrawer(),
      body: SafeArea(
          child: Column(
            children: [
              // Text(receivedData==null ? "no data received" : receivedData.toString()),
              // Column(
              //   children: [
              //     GridView.count(
              //       // mainAxisSpacing: 10,
              //       // crossAxisSpacing: 5,
              //       crossAxisCount: 2,
              //       children: List.generate(10, (index){
              //         return Center(
              //           child: Text('data $index'),
              //         );
              //       }),
              //     ),
              //   ],
              // ),
            ],
          ),
      ),
    );
  }
}
