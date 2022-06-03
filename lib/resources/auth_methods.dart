import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _firebaseAuth.currentUser!; // this User for firebase

    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up user

  Future<String> signUpUser({
    required String email,
    required String password,
    required String bio,
    required String username,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          username.isNotEmpty) {
        //register user
        UserCredential cred = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        //image
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        //add user to our database
        //yukarida karisiklik olmamasi icin user.dart ı as model şeklinde belirttik.
        model.User user = model.User(
          username: username,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
          uid: cred.user!.uid,
        );
        await _firebaseFirestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            ); //yukarida olustudugumuz user model clasındaki toJson metodunu verdik.
        // toJson metodu verileri json formatına çeviriyor.
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted.';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  // Login user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
    return res;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
