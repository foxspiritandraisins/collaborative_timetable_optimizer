import 'package:collaborative_timetable_optimizer/screens/dashboard.dart';
import 'package:collaborative_timetable_optimizer/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class menubardrawer extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        children: [
          const DrawerHeader(
            child: Column(
              children: [
                Text("Header"),
                Column(
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text("email"),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.dashboard),
                    SizedBox(width: 15,),
                    Text("Dashboard"),
                  ],
                ),
                onTap: () => Navigator.popUntil(context, ModalRoute.withName(Dashboard.id)),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 15,),
                    Text("Profile"),
                  ],
                ),
                onTap: ()=> Navigator.pushNamed(context, profile.id),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 15,),
                    Text("Logout"),
                  ],
                ),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}