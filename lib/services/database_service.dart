import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late final String? uid;
  DatabaseService({required this.uid});

  //refrence collection
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  //saving the user data_
  Future saveUserData(String name, String email) async {
    return await usersCollection.doc(uid).set({
      "Name": name,
      "email": email,
      "Profilepic": "",
      "uid": uid,
    });
  }


}
