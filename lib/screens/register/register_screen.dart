import 'package:flutter/material.dart';
import 'package:halo/constants.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                        Text("ĐĂNG KÝ",
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
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0,16,0,0),
                            child: Text("Số điện thoại",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ),
                          const TextField(
                            style: TextStyle(
                                fontSize: 24
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 16,0,0),
                            child: Text("Mật khẩu",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0,0,0,0),
                            child: TextField(
                              style: TextStyle(
                                  fontSize: 24
                              ),
                              obscureText: true,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.visibility)
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 16,0,0),
                            child: Text("Nhập lại mật khẩu",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0,0,0,32),
                            child: TextField(
                              style: TextStyle(
                                  fontSize: 24
                              ),
                              obscureText: true,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.visibility)
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("ĐĂNG KÝ"),
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
