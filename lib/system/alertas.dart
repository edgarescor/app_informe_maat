import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:informes_maat_movil/login/Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'provaider/db_provaider.dart';

class Alertas {
  static final Alertas alerta = new Alertas._();
  Alertas._();

  datoIncompletos(BuildContext context, String mensaje) {
    return Alert(
      style: AlertStyle(
          titleStyle: TextStyle(
              fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold),
          descStyle: TextStyle(fontFamily: "Montserrat-Regular")),
      context: context,
      type: AlertType.error,
      title: "Atención",
      desc: "$mensaje",
      buttons: [
        DialogButton(
          child: Text(
            "Continuar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  salir_sistema(BuildContext context) {
    return Alert(
      style: AlertStyle(
          titleStyle: TextStyle(
              fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold),
          descStyle: TextStyle(fontFamily: "Montserrat-Regular")),
      context: context,
      type: AlertType.info,
      title: "Atencion",
      desc: "Esta por salir del sistema, Desea continuar con esta accion?",
      buttons: [
        DialogButton(
          child: Text(
            "Continuar",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Montserrat-Regular",
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            DBprovaider.db.eliminartodo();
            final route = MaterialPageRoute(builder: (context) {
              return LoginPague();
            });
            Navigator.pushAndRemoveUntil(context, route, (route) => false);
          },
          width: 120,
        )
      ],
    ).show();
  }

  error_dos_conexiones(BuildContext context) {
    return Alert(
      style: AlertStyle(
          titleStyle: TextStyle(
              fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold),
          descStyle: TextStyle(fontFamily: "Montserrat-Regular")),
      context: context,
      type: AlertType.info,
      title: "Atencion",
      desc:
          "Se detecto una doble conexion en su cuenta, por seguridad todas las seciones seran cerradas, si este mensaje persite lo invitamos a contactarnos por soporte tecnico.",
      buttons: [
        DialogButton(
          child: Text(
            "continuar",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Montserrat-Regular",
                fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  fallo_mensaje(BuildContext context, String mensaje) {
    return Alert(
      style: AlertStyle(
          titleStyle: TextStyle(
              fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold),
          descStyle: TextStyle(fontFamily: "Montserrat-Regular")),
      context: context,
      type: AlertType.error,
      title: "Atención",
      desc: "$mensaje",
      buttons: [
        DialogButton(
          child: Text(
            "Continuar",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Montserrat-Regular",
                fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  alerta_informecomercial(BuildContext context, String numero, var url,
      String mensaje, int estado) {
    if (estado == 200) {
      return Alert(
        style: AlertStyle(
            titleStyle: TextStyle(
                fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold),
            descStyle: TextStyle(fontFamily: "Montserrat-Regular")),
        context: context,
        type: AlertType.success,
        title: "Atención",
        desc: "$mensaje",
        buttons: [
          DialogButton(
            child: Text(
              "Continuar",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              _launchURL(
                  'https://wa.me/56$numero?text=Estimado%20Cliente,%20le%20hacemos%20entrega%20de%20su%20informe%20comercial:$url');
              /* launchURLSOPORTE(numero, url,
                  'https://wa.me/$numero?text=Estimado%20Cliente,%20le%20hacemos%20entrega%20de%20su%20informe%20comercial:$url');*/
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      return Alert(
        style: AlertStyle(
            titleStyle: TextStyle(
                fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold),
            descStyle: TextStyle(fontFamily: "Montserrat-Regular")),
        context: context,
        type: AlertType.error,
        title: "Atención",
        desc: "$mensaje",
        buttons: [
          DialogButton(
            child: Text(
              "Continuar",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }

  _launchURL(var call) async {
    dynamic url = call;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("fallo la apertura de whatsapp");
    }
  }

  launchURLSOPORTE(String numero, String ruta, var url2) async {
    const url = "https://google.com";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("fallo la apertura de whatsapp");
    }
  }
}
