import 'package:flutter/material.dart';
import 'package:halo/constants.dart';

import 'controller/profile_controller.dart';
import 'package:get/get.dart';

class UserBlockScreen extends StatelessWidget {
  const UserBlockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Danh sách bạn bè đã chặn"),
          backgroundColor: primaryColor,
          centerTitle: true,
        ),
        body: Obx(() =>  Column(
          children: List.generate(
              profileController.userBlocked.length,
                  (index) => Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          '$urlFiles/${profileController.userBlocked[index].avatar}', width: 60, height: 60,),
                        const SizedBox(width: 8,),
                        Text(profileController
                            .userBlocked[index].username),
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        profileController.unBlock(index);

                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(8))

                        ),
                        child: const Text("Bỏ chặn", style: TextStyle(color: Colors.white,),),
                      ),

                    )
                  ],
                ),
              )),
        )),
      ),
    );
  }
}
