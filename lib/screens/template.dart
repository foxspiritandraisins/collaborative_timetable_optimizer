import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_timetable_optimizer/components/menubarDrawer.dart';
import 'package:collaborative_timetable_optimizer/components/roundBtn.dart';
import 'package:collaborative_timetable_optimizer/screens/editTimetable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Template extends StatefulWidget {
  static String id = 'template';

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  late String startWeek,
      endWeek, timetableName;
  late String startTime, endTime;
  late int intervals;
  late final String? receivedData;

  List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _somefunctions();
  }
  Future<void> getTimetableData() async {
    DocumentSnapshot<Map<String, dynamic>> timetableInfo = await db.collection('timetable').doc(receivedData).get();
    var data = timetableInfo.data() as Map<String, dynamic>;
    startWeek = data['Start Week'] as String;
    endWeek = timetableInfo['End Week'] as String;
    startTime = timetableInfo['startTime'];// as TimeOfDay;
    endTime = timetableInfo['endTime'];// as TimeOfDay;
    intervals = timetableInfo['interval'] as int;
    timetableName = timetableInfo['timetableName'] as String;

    TimeOfDay thetime = timetableInfo['startTime'];
    // var endedTime = int.parse(startTime.split(':')[0]);//  as TimeOfDay;
    print(thetime.toString());

  }
  void _somefunctions(){

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    receivedData = ModalRoute.of(context)?.settings.arguments.toString();
    getTimetableData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // receivedData = ModalRoute.of(context)?.settings.arguments.toString();


    // void moveToLast<T>(List<T> aList){
    //     int startIndex = daysOfWeek.indexOf(startWeek);   //4
    //     int endIndex = daysOfWeek.indexOf(endWeek);       //2
    //   /// if start tue, end mon? for loop first, translate to if()
    //     //for(int i=0; i<num;i++)
    //     // for(int i = 0; i< daysOfWeek.length; i++){
    //       if(startIndex!=0){
    //         print("startIndex: $startIndex , $startWeek");
    //         print("endIndex: $endIndex , $endWeek");
    //         T first = aList.removeAt(0);
    //         aList.add(first);
    //       }else{
    //         ///remove unused day
    //         if(daysOfWeek[daysOfWeek.length-1]!=endWeek){
    //           aList.removeAt((daysOfWeek.length) - 1);
    //           print("removed last index");
    //         }
    //       }
    //     // }
    // }
    // for(int i = 0; i< daysOfWeek.length; i++){
    //   moveToLast(daysOfWeek);
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('template'),
      ),
      drawer: menubardrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(receivedData.toString()),
            // TimePickerDialog(initialTime: initialTime),
            Container(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  roundBtn(
                    onPressed: () {
                      // print(Timestamp.now().toDate());
                      // DateTime adate = DateTime(2025,8,4,19,10);
                      // adate.add(Duration(hours: 1));
                      // print(adate.add(Duration(hours: 1)));

                      ///convert string timeofday to actual
                      String txtTime = "TimeOfDay(17:00)";
                    },
                    label: "button",
                    buttonColor: Colors.yellowAccent,
                    borderRadius: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
/*
      ///copied from create grid list
      ///https://docs.flutter.dev/cookbook/lists/grid-lists
      GridView.count(
        crossAxisCount: daysOfWeek.length,
        children: List.generate(daysOfWeek.length, (index) {
          return Center(
            child: Text(
              daysOfWeek[index],
              style: TextTheme.of(context).headlineSmall,
            ),
          );
        }),
      ),
      */
    //   );
    // }
  }
}
