import 'package:collaborative_timetable_optimizer/screens/addInfo.dart';
import 'package:collaborative_timetable_optimizer/screens/addTimetable.dart';
import 'package:collaborative_timetable_optimizer/screens/dashboard.dart';
import 'package:collaborative_timetable_optimizer/screens/editTimetable.dart';
import 'package:collaborative_timetable_optimizer/screens/login.dart';
import 'package:collaborative_timetable_optimizer/screens/profile.dart';
import 'package:collaborative_timetable_optimizer/screens/registration.dart';
import 'package:collaborative_timetable_optimizer/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// void main() {
  runApp(TimetableOptimizer());
}

class TimetableOptimizer extends StatefulWidget {
  @override
  State<TimetableOptimizer> createState() => _TimetableOptimizerState();
}

class _TimetableOptimizerState extends State<TimetableOptimizer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'collaborative timetable optimizer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          registration.id: (context) => registration(),
          Dashboard.id: (context) => Dashboard(),
          addTimetable.id: (context) => addTimetable(),
          addInfo.id: (context) => addInfo(),
          profile.id: (context) => profile(),
          editTimetable.id: (context) => editTimetable(),
        },
      ),
    );
  }
}
