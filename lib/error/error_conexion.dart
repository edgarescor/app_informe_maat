import 'package:flutter/material.dart';
import 'package:informes_maat_movil/splash.dart';

class ErrorConexion extends StatefulWidget {
  ErrorConexion({Key? key}) : super(key: key);

  @override
  _ErrorConexionState createState() => _ErrorConexionState();
}

class _ErrorConexionState extends State<ErrorConexion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFFFFFF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/no-connection.gif'),
            Container(
              child: Text(
                "Lamentamos informarte que perdiste tu conexion internet.",
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => Splas_ini()));
                },
                padding: EdgeInsets.all(12),
                color: Colors.red,
                child: Text('Reintentar conexion',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
