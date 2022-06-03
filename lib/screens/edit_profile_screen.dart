import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

import '../widgets/text_field_input.dart';

class EditProfileScreen extends StatefulWidget {
  final snap;
  const EditProfileScreen({Key? key, this.snap}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          InkWell(
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(uid: widget.snap['uid']),
                    ),
                  ),
              child: const Icon(Icons.done)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(
                (widget.snap as dynamic)['photoUrl'],
              ),
            ),
          ),
          Center(child: Text('Change profile photo')),
          const Text('Username'),
          TextFieldInput(
            controller: nameController,
            hintText: (widget.snap as dynamic)['username'],
            textInputType: TextInputType.text,
          ),
          const Text('Biography'),
          TextFieldInput(
            controller: bioController,
            hintText: (widget.snap as dynamic)['bio'],
            textInputType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
