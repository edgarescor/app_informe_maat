import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:informes_maat_movil/error/error_conexion.dart';
import 'package:informes_maat_movil/home/home.dart';

class Cargador_ini extends StatefulWidget {
  Cargador_ini({Key? key}) : super(key: key);

  @override
  _Cargador_iniState createState() => _Cargador_iniState();
}

class _Cargador_iniState extends State<Cargador_ini> {
  redireccion() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomeApp()));
  }

  @override
  void initState() {
    // TODO: implement initState6D:B6:33:4E:8A:93:48:E4:F0:4C:1F:2D:4A:60:0B:DF:51:1F:40:04

    super.initState();

    Timer(Duration(seconds: 5), () => redireccion());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('assets/slippers.png'),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/loader1.gif'),
            SizedBox(
              height: 15,
            ),
            Text("Cargando.."),
            SizedBox(
              width: 250.0,
              child: FadeAnimatedTextKit(
                totalRepeatCount: 100,
                duration: Duration(seconds: 6),
                text: [
                  "Cargando el Sistema..",
                  "Cargando el Sistema..",
                  "Cargando el Sistema..",
                  "Cargando el Sistema..",
                  "Cargando el Sistema..",
                  "Cargando el Sistema..",
                  "Cargando el Sistema..",
                  " Esto puede tardar un poco..",
                  " Esto puede tardar un poco..",
                  "Cargando el Sistema..",
                  " Esto puede tardar un poco..",
                  " Esto puede tardar un poco.."
                ],
                textStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
                // or Alignment.topLeft
              ),
            )
          ],
        ),
      ),
    );
  }
}
