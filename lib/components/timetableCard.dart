import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
final db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class TimetableDetails{
  final String id, timetableName;
  final DateTime lastModified;
  final int? joinedUser;
  final String? ownerName;
  final int type;
  late final int expired;

  TimetableDetails({
    this.joinedUser,
    this.ownerName,
    required this.timetableName,
    required this.id,
    required this.lastModified,
    required this.type,
    required this.expired,
  });

  factory TimetableDetails.fromFirestore(
      {required DocumentSnapshot<Map<String, dynamic>> doc, required int typeInt, String? ownerNameStr}){
    final data = doc.data() as Map<String, dynamic>;

    Map<String, dynamic> range = doc['range'];
    Timestamp to = range['to'];
    DateTime toDateTime = to.toDate();
    //compareTo = a earlier than b
    //if b earlier, return 1, if a earlier(b late), return -1
    int expiredValue = Timestamp.now().toDate().compareTo(toDateTime);
    if(expiredValue==0) {
      expiredValue = 1;
    }
    if (typeInt == 1) {
      return TimetableDetails(
        id: doc.id,
        timetableName: data['timetableName'] as String,
        lastModified: (data['last Modified'] as Timestamp).toDate(),
        type: typeInt,
        expired: expiredValue,
      );
    }else{
      return TimetableDetails(
          id: doc.id,
          timetableName: data['timetableName'] as String,
          lastModified: (data['last Modified'] as Timestamp).toDate(),
          type: typeInt,
          expired: expiredValue,
          joinedUser: data['joinedUser'] as int,
          ownerName: ownerNameStr
      );
    }
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'ID: $id, owner Name: $ownerName\n'
        'timetable name: $timetableName, last modified: $lastModified\n'
        'type: $type joined users: $joinedUser \n';
  }
}
Future<List<TimetableDetails>> getTimetableData(List<Map<String, dynamic>> aList) async{
  List<TimetableDetails> allTimetable = [];
  for(var anElement in aList){
    try{
      String collectionName = anElement['type'] == 1 ? 'timetable': 'sharedTimetable';
      DocumentSnapshot<Map<String, dynamic>> timetableDoc = await db.collection(collectionName).doc(anElement['id']).get();
      //1 = owned, 2 = shared
      if(timetableDoc.exists){
        final String ownerID = timetableDoc['ownerID'] as String;
        String username = 'me';
        if(anElement['type'] == 2 && _auth.currentUser!.uid!=ownerID){    //if shared and ownerID == me?
          DocumentSnapshot<Map<String, dynamic>> docSnap = await db.collection('users').doc(ownerID).get();
          username = '${docSnap['Lastname']} ${docSnap['Firstname']}';
        }
        TimetableDetails details = TimetableDetails.fromFirestore(doc: timetableDoc, typeInt: anElement['type'], ownerNameStr: username);
        allTimetable.add(details);
      }else{
        print("the timetable with ID ${anElement['id']} does not exist.");
      }
    }catch(e){
      print(e);
    }
  }
  return allTimetable;
}