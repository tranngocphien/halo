import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/screens/newfeed/components/body.dart';

class NewFeedScreen extends StatelessWidget {
  const NewFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Body(),
    );
  }
}

