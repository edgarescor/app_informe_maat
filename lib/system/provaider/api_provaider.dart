import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:informes_maat_movil/system/provaider/db_provaider.dart';
import 'package:http/http.dart' as http;

class ApiProvaider {
  static final ApiProvaider apiMaat = new ApiProvaider._();
  ApiProvaider._();

  addtokenphone() async {
    final token = await DBprovaider.db.gettoken();
    final usuario = await DBprovaider.db.dataUsuario();
    final rr;

    var map = {};
    map['token_phone'] = token;
    map['rut_usuario'] = usuario[0]['rut'];
    String str = json.encode(map);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encodedff = stringToBase64.encode(str);
    final url =
        Uri.parse("https://servicios.maat.cl/api/maat/addtoken/$encodedff");
    print("esta es la url de la actualizacion de token: $url");
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      var parserJson = json.decode(respuesta.body);
      final accion = parserJson['accion'];
      rr = accion;
    } else {
      rr = 999;
    }
    return rr;
  }
}
