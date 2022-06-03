import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';

import '../models/user.dart';

class FollowingScreen extends StatefulWidget {
  final List list;
  const FollowingScreen({Key? key, required this.list}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            return Text(widget.list[index]);
          }),
    );
  }
}
