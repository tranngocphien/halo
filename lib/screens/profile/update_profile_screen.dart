import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:halo/constants.dart';
import 'package:halo/models/gender.dart';

import 'controller/profile_controller.dart';


class UpdateProfileScreen extends StatefulWidget {

  UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ProfileController profileController = Get.find();
  Gender _gender = Gender.male;


  final tfNameController = TextEditingController();
  final tfAddressController = TextEditingController();
  final tfDescriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    tfNameController.text = profileController.userInfo.value!.username;
    tfDescriptionController.text = profileController.userInfo.value!.description;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chỉnh sửa thông tin"),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  TextFormField(
                    controller: tfNameController,
                    style: const TextStyle(fontSize: 14),
                    decoration:
                        const InputDecoration(labelText: "Tên tài khoản"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: tfAddressController,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(labelText: "Địa chỉ"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: Radio<Gender>(
                          value: Gender.male,
                          groupValue: _gender,
                          onChanged: (value) async {
                            setState(() {
                              _gender = value!;
                              profileController.gender.value = value;
                            });

                          },
                        ),
                        title: const Text(
                          "Nam",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      ListTile(
                        leading: Radio<Gender>(
                          value: Gender.female,
                          groupValue: _gender,
                          onChanged: (value) async {
                            setState(() {
                              _gender = value!;
                              profileController.gender.value = value;
                            });

                          },
                        ),
                        title: const Text(
                          "Nữ",
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: tfDescriptionController,
                    style: const TextStyle(
                        fontSize: 14, overflow: TextOverflow.ellipsis),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(labelText: "Mô tả"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: whiteColor,
                        primary: primaryColor,
                        minimumSize: Size(200, 60),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      onPressed: () {
                        profileController.updateInfo(tfNameController.text, tfAddressController.text, _gender, tfDescriptionController.text);
                        Navigator.pop(context);

                      },
                      child: const Text(
                        "Sửa thông tin",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
