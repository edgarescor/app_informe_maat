import 'dart:async';

import 'package:flutter/material.dart';
import 'package:informes_maat_movil/error/error_conexion.dart';
import 'package:informes_maat_movil/login/Login.dart';

class Splas_ini extends StatefulWidget {
  Splas_ini({Key? key}) : super(key: key);

  @override
  _Splas_iniState createState() => _Splas_iniState();
}

class _Splas_iniState extends State<Splas_ini> {
  // String conexion;

  redireccion() {
    Timer(
        Duration(seconds: 1),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginPague())));
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    /*VerificarConexion.alerta.initConnectivity();
    VerificarConexion.alerta.connectivitySubscription = VerificarConexion
        .alerta.connectivity.onConnectivityChanged
        .listen(VerificarConexion.alerta.updateConnectionStatus);*/

    Timer(Duration(seconds: 5), () => redireccion());
  }

  @override
  void dispose() {
    //VerificarConexion.alerta.connectivitySubscription.cancel();
    super.dispose();
  }

  Widget _colorFondo() {
    return Container(
      decoration: new BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/fondo.gif"), fit: BoxFit.cover)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _colorFondo(),
        Center(
          child: Image.asset(
            "assets/slippers.png",
            height: 250,
            width: 250,
          ),
        )
      ],
    );
  }
}
