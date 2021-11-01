import 'package:flutter/material.dart';
import 'package:halo/screens/newfeed/components/post.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Container(
            color: whiteColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                const Padding(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Text(
                    "halo",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 32,
                        fontFamily: "Time",
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.search)),
                    IconButton(onPressed: () {  }, icon: Icon(Icons.notifications),)
                  ],

                )
              ],
            ),
          ),
          Container(
            height: 100,
            color: Colors.red,
          ),
          Post(),
          Post()
        ],

      ),
    );
  }
}


