import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_timetable_optimizer/components/menubarDrawer.dart';
import 'package:collaborative_timetable_optimizer/components/roundBtn.dart';
import 'package:collaborative_timetable_optimizer/components/timetableCard.dart';
import 'package:collaborative_timetable_optimizer/screens/addTimetable.dart';
import 'package:collaborative_timetable_optimizer/screens/editTimetable.dart';
import 'package:collaborative_timetable_optimizer/screens/template.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  static String id = 'dashboard';

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late String username = "Username";

  List<Map<String, dynamic>> allUserTimetable = [],
      allList = [];
  List<String> sharedTimetable = [],
      ownedTimetable = [];
  late Future<List<TimetableDetails>> _timetablefuture;

  @override
  void initState() {
    super.initState();
    String uid = _auth.currentUser!.uid;
    db.collection('users').doc(uid).get().then(
            (DocumentSnapshot doc) {
          doc.data() as Map<String, dynamic>;
          setState(() {
            username = '${doc['Lastname']} ${doc['Firstname']}';
          });
        });

    _timetablefuture = _getAndSetUserTimetable();
  }
  Future<List<TimetableDetails>> _getAndSetUserTimetable() async{
    String uid = _auth.currentUser!.uid;

    DocumentSnapshot doc = await db.collection('users').doc(uid).get();
    ownedTimetable.addAll(List<String>.from(doc['ownedTimetable'] ?? []));
    sharedTimetable.addAll(List<String>.from(doc['sharedTimetable'] ?? []));

    addToAList(ownedTimetable, 1);
    addToAList(sharedTimetable, 2);
    return await getTimetableData(allList);
  }
  void addToAList(List<String> list, int intType) {
    for (int i = 0; i < list.length; i++) {
      Map<String, dynamic> data = {'type': intType, 'id': list[i]};
      allList.add(data);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: menubardrawer(),
      body: Padding(
        padding: const EdgeInsets.only(left: 10,bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "welcome, $username",
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 290,
                  child: Row(
                    // Distribute buttons evenly with spacing
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      roundBtn(
                        onPressed: () {
                          Navigator.pushNamed(context, addTimetable.id);
                        },
                        borderRadius: 15,
                        label: "Add Timetable",
                        buttonColor: Colors.blue,
                      ),
                      roundBtn(
                        onPressed: () {},
                        borderRadius: 15,
                        label: "Join",
                        buttonColor: Colors.blue,
                      ),
                      roundBtn(onPressed: () {
                        setState(() {

                        });
                      },
                          borderRadius: 15,
                          label: "Delete",
                          buttonColor: Colors.red),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: _timetablefuture,
                            builder: (context, snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }else if(snapshot.hasError){
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }else if(!snapshot.hasData|| snapshot.data!.isEmpty){
                                return Center(
                                  child: Text('no timetable available now'),
                                );
                              }else{
                                return SingleChildScrollView( // <--- Important: Wrap Column in SingleChildScrollView if it might exceed screen height
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.min, // Often good practice for Column inside SingleChildScrollView
                                    children: snapshot.data!.map((timetable) {
                                      String ownerNameNJoinedUser = timetable.ownerName == null ?
                                      'Owned by: me' :
                                      'Owned by: ${timetable.ownerName} \t Joined user: ${timetable.joinedUser}';
                                      return Card.filled(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8
                                        ),
                                        elevation: 4, //add shadow
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              Navigator.pushNamed(context, editTimetable.id, arguments: timetable.id);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              gradient: LinearGradient(
                                                colors: timetable.expired ==1 ?
                                                [Colors.white,Colors.grey] : [Colors.white,Color(0xFFB9F6CA)],
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                  stops: [0.6,0.9]
                                              )
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    timetable.timetableName,
                                                    // timetable.timetableName,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.deepPurple,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    ownerNameNJoinedUser,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  const SizedBox(
                                                    height: 4,//8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        size: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        'Last modified: ${timetable.lastModified.toLocal().toString().split('.')[0]}',
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontStyle: FontStyle.italic,
                                                          color: Colors.grey[700],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(), // <--- Convert the Iterable to a List of Widgets for Column children
                                  ),
                                );
                              }
                            }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}