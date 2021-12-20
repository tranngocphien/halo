import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rPasswordReController = TextEditingController();
  final _usernameController = TextEditingController();

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
        title: Text("Đăng ký"),
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
                      _errorMsg == null
                          ? Container()
                          : Text(
                              _errorMsg,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      TextFormField(
                        controller: _phoneController,
                        style: const TextStyle(fontSize: 20),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Số điện thoại"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(hintText: "Tên tài khoản"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(hintText: "Mật khẩu"),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _rPasswordReController,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                            hintText: "Nhập lại mật khẩu"),
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Nhập lại mật khẩu không đúng";
                          }
                        },
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
                              register(
                                  _usernameController.text,
                                  _passwordController.text,
                                  _phoneController.text);
                            }
                          },
                          child: const Text(
                            "Đăng ký",
                            style: TextStyle(fontSize: 20),
                          ))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> register(
      String username, String password, String phonenumber) async {
    Map data = {
      'phonenumber': phonenumber,
      'password': password,
      'username': username
    };
    var jsonResponse = null;
    var response =
        await http.post(Uri.parse("${urlApi}/users/register"), body: data);
    if (response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
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
