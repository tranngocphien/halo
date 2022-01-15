import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halo/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _passwordController = TextEditingController();
  final _rPasswordReController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  var _isLoading = false;
  var _errorMsg;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _rPasswordReController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Đổi mật khẩu"),
      ),
      body: SingleChildScrollView(
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
                  controller: _currentPasswordController,
                  style: const TextStyle(fontSize: 20),
                  decoration:
                      const InputDecoration(hintText: "Mật khẩu hiện tại"),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(hintText: "Mật khẩu mới"),
                  obscureText: true,

                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _rPasswordReController,
                  style: const TextStyle(fontSize: 20),
                  decoration:
                      const InputDecoration(hintText: "Nhập lại mật khẩu"),
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
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        change_password(_currentPasswordController.text,
                            _passwordController.text);
                        setState(() {
                          _isLoading = true;
                          _errorMsg = "";
                        });

                      }

                    },
                    child: const Text(
                      "Đổi mật khẩu",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> change_password(
      String currentPassword, String newPassword) async {
    Map data = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    var jsonResponse = null;
    var response = await http.post(Uri.parse("${urlApi}/users/change-password"),
        body: data,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token}'});
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        const snackBar = SnackBar(
          content: Text('Đổi mật khẩu thành công'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
