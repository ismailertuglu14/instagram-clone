import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profileImage;
  final dynamic likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'postId': postId,
        'username': username,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profileImage': profileImage,
        'likes': likes,
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
    );
  }
}
