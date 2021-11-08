import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halo/components/circle_avatar.dart';

class Request extends StatelessWidget {
  const Request({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/images/profile_avatar.jpg"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Tên người dùng", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: (){
                      print("addfiend");
                    },
                    child: Container(
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text('Xác nhận', style: TextStyle(color: Colors.white),)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: (){
                      print("addfiend");
                    },
                    child: Container(
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: Color(0x00FFA0A2A3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text('Xóa')
                    ),
                  ),
                )
              ],
            )

          ],
        ),
      ),
    );
  }

}