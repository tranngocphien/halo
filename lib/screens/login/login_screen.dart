import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:halo/models/user_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  var _errorMsg;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Đăng nhập"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: whiteColor,
            ))
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Image.asset("assets/images/welcome_screen_removebg.png",
                          height: 250, width: 250),
                      const Text("HALO",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 60,
                              color: primaryColor)),
                      _errorMsg == null
                          ? Container()
                          : Text(
                              _errorMsg,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 70.0, left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          child: TextFormField(
                            controller: _phoneController,
                            style: TextStyle(fontSize: 20),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Số điện thoại",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            validator: (value) {
                              if (value!.length < 5) {
                                return "Số điện thoại không hợp lệ";
                              }
                              if (value == null || value.isEmpty) {
                                return 'Hãy nhập số điện thoại';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          child: TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                                hintText: "Mật khẩu",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15)),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Hãy nhập mật khẩu';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: whiteColor,
                            primary: primaryColor,
                            minimumSize: Size(220, 50),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          onPressed: () {
                            print(_phoneController.text);
                            print(_passwordController.text);
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                                _errorMsg = "";
                              });
                              login(_phoneController.text,
                                  _passwordController.text);
                            }
                          },
                          child: const Text(
                            "Đăng nhập",
                            style: TextStyle(fontSize: 20),
                          ))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void login(String phonenumber, String password) async {
    Map data = {'phonenumber': phonenumber, 'password': password};
    var jsonResponse = null;
    var response =
        await http.post(Uri.parse("${urlApi}/users/login"), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', jsonResponse['token']);
        prefs.setString('userId', jsonResponse['data']['id']);
        UserInfo.userId = jsonResponse['data']['id'];

        Navigator.pushNamed(context, "/main");
      }
    } else {
      jsonResponse = json.decode(response.body);

      setState(() {
        _isLoading = false;
      });
      _errorMsg = jsonResponse['message'];
    }
  }
}
