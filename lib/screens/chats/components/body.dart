import 'package:flutter/material.dart';
import 'package:halo/components/filled_outline_button.dart';
import 'package:halo/components/primary_button.dart';
import 'package:halo/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: primaryColor,
          child: Row(
            children: [
              FillOutlineButton(press: () {}, text: "Recent Message"),
              SizedBox(width: kDefaultPadding),
              FillOutlineButton(text: "Active", press: (){}, isFilled: false,)
            ],
          ),
        ),
        Expanded(child:
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              )
            ),
            child: ListView(
              children:  [
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "/message");
                  },
                  child: ListTile(
                    leading: Icon(Icons.account_circle, size: 40,),
                    title: Text("Tên người dùng"),
                    subtitle: Text("Tin nhắn gần đây"),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle, size: 40,),
                  title: Text("Tên người dùng"),
                  subtitle: Text("Tin nhắn gần đây"),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle, size: 40,),
                  title: Text("Tên người dùng"),
                  subtitle: Text("Tin nhắn gần đây"),
                )
              ],
            ),
          ))
      ],
    );
  }
}
