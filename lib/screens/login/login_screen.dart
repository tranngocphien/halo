import 'package:flutter/material.dart';
import 'package:halo/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: size.height,
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: size.height * 0.3,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [primaryColor, Colors.white],
                          )),
                        ),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back, size: 30,)),
                        const Positioned(
                          child:
                            Text("ĐĂNG NHẬP",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            left: 24,
                            bottom: 24,),

                  ],),
                  Container(
                    width: double.infinity,
                    height: size.height*0.7,
                    padding: EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextField(
                          style: TextStyle(
                            fontSize: 24
                          ),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Số điện thoại",
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.fromLTRB(0,32,0,32),
                          child: TextField(
                            style: TextStyle(
                              fontSize: 24
                            ),
                            obscureText: true,
                            decoration: InputDecoration(
                              focusedBorder:OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor)),
                              border: OutlineInputBorder(),
                              labelText: "Mật khẩu",
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: Icon(Icons.visibility)
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/main");
                              },
                              child: const Text("ĐĂNG NHẬP"),
                              style: ElevatedButton.styleFrom(
                                  primary: primaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ],
          )),
        ),
      ),
    );
  }
}
