import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  String userId;
  String faceId;
  String email;
  String name;


  Users({required this.userId , required this.faceId, required this.email, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'faceId' : faceId,
      'email': email,
      'name': name,
    };
  }

  Users.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : userId = doc.id,
        faceId = doc.data()!["faceId"],
        email = doc.data()!["email"],
        name = doc.data()!["name"];


  Users.fromMap(Map<String, dynamic> userMap)
      : userId = userMap["userId"],
        faceId = userMap["faceId"],
        email = userMap["email"],
        name = userMap["name"];
}

//user name: admin@gmail.com
//password: admin123