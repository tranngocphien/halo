import 'package:flutter/material.dart';
import 'package:halo/constants.dart';

class RegisterError extends StatelessWidget {
  const RegisterError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          color: Colors.red,
        ),
      ),
    );
  }
}
