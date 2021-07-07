import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:informes_maat_movil/home/draw.dart';
import 'package:informes_maat_movil/login/Login.dart';
import 'package:informes_maat_movil/model/rut_model.dart';
import 'package:informes_maat_movil/model/usuarios_model.dart';
import 'package:informes_maat_movil/service/push_notification_service.dart';
import 'package:informes_maat_movil/system/alertas.dart';
import 'package:informes_maat_movil/system/provaider/api_provaider.dart';
import 'package:informes_maat_movil/system/provaider/conexion_provaider.dart';
import 'package:informes_maat_movil/system/provaider/db_provaider.dart';
import 'package:http/http.dart' as http;

import 'package:dropdown_below/dropdown_below.dart';

enum SingingCharacter { simple, consolidado, empresarial, certificado, os10 }

class HomeApp extends StatefulWidget {
  HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  TextEditingController _rutController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String tipo_informe = "NO";
  String rut_cliente = "";
  int _value = 0;
  String telefono = "";
  String email = "";
  Widget informeSimple = SizedBox();
  Widget informeConsolidado = SizedBox();
  Widget informeFull = SizedBox();
  Widget informeCertificado = SizedBox();
  Widget informeOs10 = SizedBox();

  SingingCharacter _character = SingingCharacter.simple;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VerificadorConexion.conexion.initConnectivity();
    tokenEquipo().then((v) {
      consultarPermisosInforme();
    });
  }

  @override
  void dispose() {
    VerificadorConexion.conexion.connectivitySubscription.cancel();
    super.dispose();
  }

  tokenEquipo() async {
    await Push_notification_service.inicialApp().then((value) {
      Timer(Duration(seconds: 3), () {
        if (VerificadorConexion.conexion.connectionStatus == "1") {
          ApiProvaider.apiMaat.addtokenphone().then((valor) {
            print("aqui el valor de la accion despues del api $valor");
            if (valor == 2) {
              Alertas.alerta.error_dos_conexiones(context).then((c) {
                Timer(Duration(seconds: 2), () {
                  DBprovaider.db.eliminartodo();
                  final route = MaterialPageRoute(builder: (context) {
                    return LoginPague();
                  });
                  Navigator.pushAndRemoveUntil(
                      context, route, (route) => false);
                });
              });
            }
          });
        }
      });
    });
  }

  reset_formulario() {
    setState(() {
      _emailController.clear();
      _telefonoController.clear();
      _rutController.clear();
    });
  }

  consultarPermisosInforme() async {
    final datos_usuario = await DBprovaider.db.datosUsuarioConectado();
    var map = {};
    map['rut_usuario'] = datos_usuario[0]['rut'].toString();
    String str = json.encode(map);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encodedff = stringToBase64.encode(str);
    final url = Uri.parse(
        "https://servicios.maat.cl/api/movil/permisoInforme/$encodedff");

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      var parseJson = json.decode(respuesta.body);
      final estado = parseJson["estado"];
      if (estado == 200) {
        Widget _info_simpl = (parseJson["informe_simple"] == "true")
            ? ListTile(
                selectedTileColor: Color(0xffC41625),
                title: const Text(
                  'Informe Simple',
                  style: TextStyle(fontFamily: "Montserrat-Regular"),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.simple,
                  groupValue: _character,
                  onChanged: (value) {
                    setState(() {
                      _character = value!;
                      tipo_informe = "SM";
                    });
                  },
                ),
              )
            : SizedBox();
        Widget _info_consolidado = (parseJson["informe_consolidado"] == "true")
            ? ListTile(
                selectedTileColor: Color(0xffC41625),
                title: const Text(
                  'Informe Consolidado',
                  style: TextStyle(fontFamily: "Montserrat-Regular"),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.consolidado,
                  groupValue: _character,
                  onChanged: (value) {
                    setState(() {
                      _character = value!;
                      tipo_informe = "C";
                    });
                  },
                ),
              )
            : SizedBox();
        Widget _info_full = (parseJson["informe_full"] == "true")
            ? ListTile(
                selectedTileColor: Color(0xffC41625),
                title: const Text(
                  'Informe Empresarial',
                  style: TextStyle(fontFamily: "Montserrat-Regular"),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.empresarial,
                  groupValue: _character,
                  onChanged: (value) {
                    setState(() {
                      _character = value!;
                      tipo_informe = "E";
                    });
                  },
                ),
              )
            : SizedBox();
        Widget _info_certificado = (parseJson["informe_certificado"] == "true")
            ? ListTile(
                selectedTileColor: Color(0xffC41625),
                title: const Text(
                  'Informe Certificado',
                  style: TextStyle(fontFamily: "Montserrat-Regular"),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.certificado,
                  groupValue: _character,
                  onChanged: (value) {
                    setState(() {
                      _character = value!;
                      tipo_informe = "A";
                    });
                  },
                ),
              )
            : SizedBox();
        Widget _info_os10 = (parseJson["informe_os10"] == "true")
            ? ListTile(
                selectedTileColor: Color(0xffC41625),
                title: const Text(
                  'Informe OS10',
                  style: TextStyle(fontFamily: "Montserrat-Regular"),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.os10,
                  groupValue: _character,
                  onChanged: (value) {
                    setState(() {
                      _character = value!;
                      tipo_informe = "S";
                    });
                  },
                ),
              )
            : SizedBox();

        setState(() {
          tipo_informe = "SM";
          informeSimple = _info_simpl;
          informeCertificado = _info_certificado;
          informeConsolidado = _info_consolidado;
          informeFull = _info_full;
          informeOs10 = _info_os10;
        });
      } else {
        setState(() {
          informeSimple = Text(
            '* Disculpe pero no tiene autorizacion para emitir informes mediante esta plataforma, para mayor informacio debe comunicarce con Soporte tecnico.',
            style: TextStyle(
                fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold),
          );
        });
      }
    }
  }

  enviarAPI(String informe, String correo, String telefono_cliente,
      String rut_cliente_informe) async {
    final datos_usuario = await DBprovaider.db.datosUsuarioConectado();
    var map = {};
    map['tipo_informe'] = informe;
    map['rut_usuario'] = datos_usuario[0]['rut'].toString();
    map['rut_cliente'] = rut_cliente_informe;
    map['correo_usuario'] = correo;

    String str = json.encode(map);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encodedff = stringToBase64.encode(str);

    final url =
        Uri.parse("https://servicios.maat.cl/api/maat/informeMovil/$encodedff");
    print("esta es la url del nuevo informe : $url");
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      var parsedJson = json.decode(respuesta.body);
      final estado = parsedJson['Estado'];
      final mensaje = parsedJson['mensaje'];
      final url;
      if (estado == 200) {
        url = parsedJson['url'];
        reset_formulario();
      } else {
        url = '';
      }
      Alertas.alerta
          .alerta_informecomercial(context, telefono, url, mensaje, estado);
    } else {
      print("fallo la conexion al api");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
        future: DBprovaider.db.getUsuariofull(),
        builder: (BuildContext contex, AsyncSnapshot<List<Usuario>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final verificador_contenido = snapshot.data;

            if (verificador_contenido![0].id == 0) {
              return Center(
                child: Text("Tenemos Problemas Tecnicos en este momento.."),
              );
            } else {
              return Scaffold(
                drawer: DrawLateral(),
                appBar: AppBar(
                  backgroundColor: Color(0xffC41625),
                  centerTitle: true,
                  title: Text(
                    "Informes Maat",
                    style: TextStyle(
                        fontFamily: "Montserrat-Regular",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                body: ListView(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: [
                    // _tarjeta_usuario(verificador_contenido[0].nombreUsuario),
                    SizedBox(
                      height: 10,
                    ),
                    _titulo(),
                    Image.asset('assets/flecha.png', width: 150, height: 30),
                    SizedBox(
                      height: 10,
                    ),
                    formulario(),
                    Container(
                        width: 265,
                        child: Text(
                          '* Su informe sera enviado por Whastapp y correo electronico.',
                          style: TextStyle(
                              fontFamily: "Montserrat-Regular",
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              );
            }
          }
        });
  }

  /** tarjeta de usuario */
  Widget _tarjeta_usuario(String usuario) {
    return Card(
      color: Color(0xffC41625),
      semanticContainer: true,
      margin: EdgeInsets.all(10),
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Informes Comerciales",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _titulo() {
    return Row(
      children: [
        Image.asset('assets/slippers.png', width: 50, height: 50),
        Container(
          height: 50,
          width: 3,
          margin: EdgeInsets.all(12),
          color: Color(0xffC41625),
        ),
        Container(
            width: 250,
            child: Text(
              'COMPLETE LOS CAMPOS PARA GENERAR SU INFORME COMERCIAL.',
              style: TextStyle(
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  Widget _separador() {
    return Row(
      children: [
        Image.asset('assets/slippers.png', width: 70, height: 70),
        Container(
          height: 70,
          width: 3,
          margin: EdgeInsets.all(12),
          color: Color(0xffC41625),
        ),
        Container(
            width: 180,
            child: Text(
              'COMPLETE LOS CAMPOS PARA GENERAR SU INFORME COMERCIAL',
              style: TextStyle(
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  Widget formulario() {
    return Column(
      children: [
        TextField(
          controller: _rutController,
          obscureText: false,
          decoration: new InputDecoration(
              enabledBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  borderSide: new BorderSide(
                      color: Color(0xffC41625), style: BorderStyle.solid)),
              hoverColor: Color(0xffC41625),
              filled: true,
              fillColor: Colors.white,
              hintText: '',
              border: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  borderSide: new BorderSide(
                      color: Color(0xffC41625), style: BorderStyle.solid)),
              labelText: "Rut del Cliente",
              prefixIcon: const Icon(
                Icons.perm_identity,
                color: Color(0xffC41625),
              ),
              prefixText: ''),
          onChanged: (valor) {
            setState(() {
              rut_cliente = valor;
              rut_cliente = RutHelper.formartRut(rut_cliente);
              _rutController.text = RutHelper.formartRut(rut_cliente);
              _rutController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _rutController.text.length));
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _telefonoController,
          autofocus: false,
          obscureText: false,
          keyboardType: TextInputType.phone,
          decoration: new InputDecoration(
              enabledBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  borderSide: new BorderSide(
                      color: Color(0xffC41625), style: BorderStyle.solid)),
              filled: true,
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  borderSide: new BorderSide(
                      color: Color(0xffC41625), style: BorderStyle.solid)),
              hintText: ' Telefono de Cliente',
              prefixIcon: const Icon(
                Icons.phone_in_talk,
                color: Color(0xffC41625),
              ),
              prefixText: '+56',
              suffixText: '',
              suffixStyle: const TextStyle(color: Colors.red, fontSize: 20)),
          onChanged: (valor) {
            setState(() {
              telefono = valor;
            });
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _emailController,
          autofocus: false,
          obscureText: false,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
              enabledBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  borderSide: new BorderSide(
                      color: Color(0xffC41625), style: BorderStyle.solid)),
              filled: true,
              fillColor: Colors.white,
              hintText: ' Correo de cliente',
              border: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  borderSide: new BorderSide(
                      color: Color(0xffC41625), style: BorderStyle.solid)),
              prefixIcon: const Icon(
                Icons.mail_outline,
                color: Color(0xffC41625),
              ),
              prefixText: '',
              suffixText: '',
              suffixStyle: const TextStyle(color: Colors.red, fontSize: 20)),
          onChanged: (valor) {
            setState(() {
              email = valor;
            });
          },
        ),
        Image.asset('assets/3puntos.png', width: 150, height: 70),
        Container(
            width: 300,
            child: Text(
              'Seleccione el tipo de informe',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            )),
        informeSimple,
        informeConsolidado,
        informeFull,
        informeCertificado,
        informeOs10,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            onPressed: () {
              if (VerificadorConexion.conexion.connectionStatus == "1") {
                if (rut_cliente == "" || rut_cliente.length < 8) {
                  Alertas.alerta.datoIncompletos(
                      context, "El Rut ingresado es Incorrecto");
                } else if (telefono == "" || telefono.length < 7) {
                  Alertas.alerta.datoIncompletos(context,
                      "El numero de Telefono Celular se Encuentra Errado. ");
                } else if (email == "") {
                  Alertas.alerta.datoIncompletos(
                      context, "Es Necesario indicar un correo electronico. ");
                } else if (tipo_informe == "NO") {
                  Alertas.alerta.datoIncompletos(
                      context, "No hay informes seleccionado. ");
                } else {
                  if (RutHelper.Check(rut_cliente)) {
                    enviarAPI(tipo_informe, email, telefono, rut_cliente);
                  } else {
                    Alertas.alerta.datoIncompletos(
                        context, "El RUT indicado es incorrecto.");
                  }
                }
              } else {
                Alertas.alerta.fallo_mensaje(context,
                    "Disculpe pero es necesario poseer una conexion a internet para continuar!.");
              }

              /*
                    final route = MaterialPageRoute(builder: (context) {
                        return MenuHome();  });
          Navigator.push(context, route);*/
            },
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 12, top: 12),
            color: Color(0xffC41625),
            child: Text('Generar Informe',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Montserrat-Regular")),
          ),
        )
      ],
    );
  }
}
