import 'package:flutter/material.dart';
import 'package:halo/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Column()),
        const Divider(thickness: 3,),
        Container(
          padding: const EdgeInsets.all(kDefaultPadding/2),
          child: SafeArea(
            child: Row(
              children: [
                const Icon(Icons.mic,color: primaryColor,),
                const SizedBox(width: 10,),
                Expanded(child:
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.sentiment_satisfied_outlined),
                          SizedBox(width: 10),
                          Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Type message",
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              )
                          ),
                          Icon(Icons.attach_file)
                        ],
                      ),
                    ),
                  )),
                const SizedBox(width: 10,),
                const Icon(
                    Icons.send,
                    color: primaryColor,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
