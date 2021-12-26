import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:halo/constants.dart';

import 'controller/profile_controller.dart';

class UpdateProfileScreen extends StatelessWidget{

  final ProfileController profileController = Get.find();

  UpdateProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin"),
        backgroundColor: primaryColor,
      ),
      body: Container(

      ),

    );
  }

}