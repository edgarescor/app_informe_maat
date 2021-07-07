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
          ListTile(
            title: Container(
              child: Image.asset(
                "assets/slippers.png",
                width: 100,
                height: 100,
              ),
            ),
            subtitle: Text(
              "Informes Comerciales",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
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
