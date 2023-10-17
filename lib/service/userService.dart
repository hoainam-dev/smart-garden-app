import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_garden_app/models/user.dart';


class UserService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Users> users = [];
  Users? user;

  //get collection user and convert to list
  Future<List<Users>> retrieveUser() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("users").get();
    return snapshot.docs
        .map((docSnapshot) => Users.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  //get all user
  Future<void> getAllUsers() async {
    var retrieveUserList = await retrieveUser();
    retrieveUserList.forEach((element) {
      Users user = Users(
          userId: element.userId,
          faceId: element.faceId,
          email: element.email,
          name: element.name
      );
      users.add(user);
      print("get User oke!");
    });
  }

  //get user
  Future<void> getUserById(String id) async {
    var retrieveUserList = await retrieveUser();
    retrieveUserList.forEach((element) {
      if(id==element.userId){
        user = Users(
            userId: element.userId,
            faceId: element.faceId,
            email: element.email,
            name: element.name
        );
      }
    });
  }

  Future<void> getUserByEmail(String email) async {
    var retrieveUserList = await retrieveUser();
    retrieveUserList.forEach((element) {
      if(element.email==email){
        user = Users(
            userId: element.userId,
            faceId: element.faceId,
            email: element.email,
            name: element.name,
        );
      }
    });
  }
}