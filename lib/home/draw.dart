import 'package:flutter/material.dart';
import 'package:informes_maat_movil/system/alertas.dart';

class DrawLateral extends StatefulWidget {
  DrawLateral({Key? key}) : super(key: key);

  @override
  _DrawLateralState createState() => _DrawLateralState();
}

class _DrawLateralState extends State<DrawLateral> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            child: Image.asset(
              "assets/header_raw.png",
              width: 1000,
              height: 190,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(10.0),
            leading: Icon(
              Icons.exit_to_app_outlined,
              color: Colors.red,
            ),
            title: Text('Salir'),
            onTap: () {
              Alertas.alerta.salir_sistema(context);
            },
          )
        ],
      ),
    );
  }
}
