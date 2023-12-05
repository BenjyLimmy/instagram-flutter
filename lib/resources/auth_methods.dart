import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Retrieve user details from FireStore and return User instance
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    //Retrieve user data from firestore using current user ID
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    //Return user data in JSON format
    return model.User.fromSnap(snap);
  }

  //User Sign-up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty &
          password.isNotEmpty &
          username.isNotEmpty &
          bio.isNotEmpty) {
        //Register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //Add user to database (.set specifies key to key-value pair, in this case UID as key)

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Logging in User

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty & password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> signOut() async {
    String res = "Some error occured";

    try {
      await _auth.signOut();

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
