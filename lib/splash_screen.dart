import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kelimbo_admin/screens/auth/auth_login.dart';
import 'package:kelimbo_admin/utils/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/logo.png"),
          )),
        ],
      ),
    );
  }
}
