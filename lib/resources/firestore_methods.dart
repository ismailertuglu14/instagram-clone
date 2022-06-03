import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = 'some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      _firebaseFirestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print(
          error.toString(),
        );
      }
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profileImage,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'postId': postId,
          'username': name,
          'profileImage': profileImage,
          'uid': uid,
          'text': text,
          'datePublished': DateTime.now(),
          'commentId': commentId,
          'likes': []
        });
      } else {
        if (kDebugMode) {
          print('Text is Empty');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  // ----------------------- Delete Post ----------------------------

  Future<void> deletePost(String postId) async {
    try {
      await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get()
          .then((value) {
        for (DocumentSnapshot snap in value.docs) {
          snap.reference.delete();
        }
      });
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  Future<void> likeComment(
      String commentId, String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  // uid=> currentUser.uid   &  followId => diğer kullanıcının id si
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firebaseFirestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  Future<String> getUserByUid(uid) async {
    String username = '';

    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(uid).get();

    username = snap['username'];
    print(username);
    return username;
  }

  Future<List> getUserFollowing(uid) async {
    List following;
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(uid).get();
    following = (snap.data()! as Map<String, dynamic>)['following'];
    return following;
  }
}
