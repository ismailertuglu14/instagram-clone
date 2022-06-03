// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profileImage']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '  ${widget.snap['text']}',
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          '   ${widget.snap['likes'].length} likes',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              print(widget.snap['commentId'] +
                  '\n ${user.uid}' +
                  '\n' +
                  widget.snap['likes'].toString());
              await FirestoreMethods().likeComment(widget.snap['commentId'],
                  widget.snap['postId'], user.uid, widget.snap['likes']);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.favorite,
                color: widget.snap['likes'].contains(user.uid)
                    ? Colors.red
                    : Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
