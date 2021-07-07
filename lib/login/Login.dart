import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:informes_maat_movil/login/cargador.dart';
import 'package:informes_maat_movil/model/contador_usuarios_model.dart';
import 'package:informes_maat_movil/model/rut_model.dart';
import 'package:informes_maat_movil/model/usuarios_model.dart';
import 'package:informes_maat_movil/service/push_notification_service.dart';
import 'package:informes_maat_movil/system/alertas.dart';
import 'package:informes_maat_movil/system/provaider/conexion_provaider.dart';
import 'package:informes_maat_movil/system/provaider/db_provaider.dart';

import 'package:http/http.dart' as https;

class LoginPague extends StatefulWidget {
  LoginPague({Key? key}) : super(key: key);

  @override
  _LoginPagueState createState() => _LoginPagueState();
}

class _LoginPagueState extends State<LoginPague> {
  TextEditingController rutController = TextEditingController();
  String _usuario = "";
  String _contrasena = "";
  String _nombre_usuario = "";
  String _rut_usuario = "";
  String _dv_usuario = "";
  String _correo_electronico = "";
  String _num_tlf = "";
  String direccion = "";
  String _tipo_plan = "";
  String _clave_acceso = "";
  String _estado = "";
  int tipo_usuario = 0;
  String id_cliente_maat = "";

  @override
  void initState() {
    // TODO: implement initState
    rutController = TextEditingController();
    VerificadorConexion.conexion.initConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    VerificadorConexion.conexion.connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
        tag: 'hero',
        child: Center(
          child: Image.asset(
            "assets/slippers.png",
            height: 200,
            width: 200,
          ),
        ));

    final email = TextField(
      controller: rutController,
      maxLength: 10,
      autofocus: true,
      obscureText: false,
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: new BorderSide(color: Colors.red)),
          hintText: 'Coloca tu Usuario',
          prefixIcon: const Icon(
            Icons.supervised_user_circle,
            color: Colors.red,
          ),
          prefixText: ' ',
          suffixText: 'Usuario',
          suffixStyle: const TextStyle(color: Colors.red, fontSize: 20)),
      onChanged: (valor) {
        //RUTValidator.formatFromTextController(_rutController);

        setState(() {
          _usuario = valor;
          _usuario = RutHelper.formartRut(_usuario);
          rutController.text = RutHelper.formartRut(_usuario);
          rutController.selection = TextSelection.fromPosition(
              TextPosition(offset: rutController.text.length));
        });
      },
    );

    final password = TextField(
      autofocus: true,
      obscureText: true,
      decoration: new InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: new BorderSide(color: Colors.red)),
          hintText: 'Coloca tu Contraseña',
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.red,
          ),
          prefixText: ' ',
          suffixText: 'Contraseña',
          suffixStyle: const TextStyle(color: Colors.red, fontSize: 20)),
      onChanged: (valor) {
        setState(() {
          _contrasena = valor;
        });
      },
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          /*
                    final route = MaterialPageRoute(builder: (context) {
                        return MenuHome();  });
          Navigator.push(context, route);*/

          // recibirString(context);
          if (VerificadorConexion.conexion.connectionStatus == "0") {
            Alertas.alerta
                .fallo_mensaje(context, "Verifique su Conexion a internet!.");
          } else {
            if (RutHelper.Check(_usuario)) {
              if (_usuario == "" || _contrasena == "") {
                Alertas.alerta
                    .fallo_mensaje(context, "Debe completar el formulario.");
              } else {
                print(
                    "listo para enviar los datos a la base de datos y verificar su existencia en el sistema");
                verificarUsuario(context, _usuario, _contrasena);
              }
            } else {
              Alertas.alerta
                  .fallo_mensaje(context, "El rut indicado es incorrecto.");
            }
          }
        },
        padding: EdgeInsets.all(12),
        color: Color(0xffC41625),
        child: Text('Entrar',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Montserrat-Regular",
                fontWeight: FontWeight.bold)),
      ),
    );

    final formulario = Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/fondo.gif"), fit: BoxFit.cover)),
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 10.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 8.0),
                loginButton,
                /*rut,
                SizedBox(height: 24.0),
                
                forgotLabel,
                soporte,
                demoSolicitud*/
              ],
            ),
          )
        ],
      )),
    );

    return FutureBuilder<List<ContadorUsuario>>(
      future: DBprovaider.db.getUsuario(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ContadorUsuario>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final verificador = snapshot.data;
          if (verificador![0].id == 0) {
            return Center(
              child: formulario,
            );
          } else {
            // return MenuHome();
            //return SplashCargado();
            return Cargador_ini();
          }

          // return Center(child: Text("El usuario puede entrar ${scan[0].id}"));

        }
      },
    );
  }

  Future verificarUsuario(
      BuildContext context, String usuario, String contrasena) async {
    var url = Uri.parse(
        "https://servicios.maat.cl/api/movil/auth_usuario/$usuario/$contrasena");
    var respuesta = await https.get(url);

    // final desarrollo = 200;
    print(respuesta.statusCode);
    if (respuesta.statusCode == 200) {
      var parsedJson = json.decode(respuesta.body);
      final estado = parsedJson['estado'];
      final String mensaje = parsedJson['mensaje'];

      if (estado == 423) {
        Alertas.alerta.fallo_mensaje(context, mensaje);
      } else {
        print(parsedJson);

        setState(() {
          _estado = "1";
          _nombre_usuario = parsedJson['nombre_usuario'];
          _rut_usuario = parsedJson['rut_usuario'].toString();
          _dv_usuario = parsedJson['dv_usuario'];
          _correo_electronico = parsedJson['correo'];
          _num_tlf = parsedJson['telefono'];
          direccion = parsedJson['direccion'];
          _tipo_plan = parsedJson['limite'].toString();
          _clave_acceso = _contrasena;
          tipo_usuario = parsedJson['tipo_usuario'];
          id_cliente_maat = parsedJson['id_cliente'].toString();
        });

        registroUsuariDB(context);
      }
    } else {
      print("fallo la conexion al api");
    }
  }

  registroUsuariDB(BuildContext context) {
    //print(_mensaje);
    //print(_estado);

    if (_estado == "0" || _estado == "" || _estado.isEmpty) {
      print("fallo");
    } else {
      final agregarUsuario = Usuario(
        claveAcceso: _clave_acceso,
        correo_usuario: _correo_electronico,
        direccion: direccion,
        dv: _dv_usuario,
        nombreUsuario: _nombre_usuario,
        rut: _rut_usuario,
        tipoPlan: _tipo_plan,
        bolsa: "",
        id: 0,
        id_cliente: "",
        tipo_usuario: tipo_usuario.toString(),
      );
      DBprovaider.db.nuevoUsuario(agregarUsuario);
      /*
      final route = MaterialPageRoute(builder: (context) {
        // return CalculatorDos();
        return MenuHome();
      });
      return Navigator.push(context, route);*/
    }
  }
}
