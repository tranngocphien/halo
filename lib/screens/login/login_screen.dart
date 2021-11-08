import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
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
      body:_isLoading? Center(child: CircularProgressIndicator(backgroundColor: whiteColor,)): SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _errorMsg == null ? Container(): Text(_errorMsg, style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),),
                TextFormField(
                  controller: _phoneController,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Số điện thoại"),
                  validator: (value){
                    if(value!.length != 10){
                      return "Số điện thoại không hợp lệ";
                    }
                    if (value == null || value.isEmpty) {
                      return 'Hãy nhập số điện thoại';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(hintText: "Mật khẩu"),
                  obscureText: true,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Hãy nhập mật khẩu';
                    }
                    return null;

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
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    onPressed: () {
                      print(_phoneController.text);
                      print(_passwordController.text);
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          _isLoading = true;
                          _errorMsg = "";
                        });
                        login(_phoneController.text, _passwordController.text);
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

  void login(String phonenumber,String password) async {
    Map data = {
      'phonenumber': phonenumber,
      'password': password
    };
    var jsonResponse = null;
    var response = await http.post(Uri.parse("http://192.168.1.9:8000/api/v1/users/login"), body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', jsonResponse['token']);

        Navigator.pushNamed(context, "/main");
      }
    }
    else {
      jsonResponse = json.decode(response.body);

      setState(() {
        _isLoading = false;
      });
      _errorMsg = jsonResponse['message'];
    }
  }
}
