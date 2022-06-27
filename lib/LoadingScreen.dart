import 'dart:async';
import 'package:aduio_player/main.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Startstate();
  }
}

class Startstate extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    statTimer();
  }

  statTimer() async {
    var duration = Duration(seconds: 6);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AllSongs()));
  }

//-------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF190033),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/1.jpg"), fit: BoxFit.fill),
          ),
        ));
  }
}
