import 'package:flutter/material.dart';
import 'dart:convert';

class Usuario {
  Usuario({
    required this.id,
    required this.rut,
    required this.dv,
    required this.nombreUsuario,
    required this.correo_usuario,
    required this.direccion,
    required this.tipoPlan,
    required this.claveAcceso,
    required this.id_cliente,
    required this.bolsa,
    required this.tipo_usuario,
  });

  int id;
  String rut;
  String dv;
  String nombreUsuario;
  String correo_usuario;

  String direccion;
  String tipoPlan;
  String claveAcceso;
  String id_cliente;
  String bolsa;
  String tipo_usuario;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        rut: json["rut"]!,
        dv: json["dv"],
        nombreUsuario: json["nombre_usuario"],
        correo_usuario: json["correo_usuario"],
        direccion: json["direccion"],
        tipoPlan: json["tipo_plan"],
        claveAcceso: json["claveAcceso"],
        id_cliente: json["id_cliente"],
        bolsa: json["bolsa"],
        tipo_usuario: json["tipo_usuario"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rut": rut,
        "dv": dv,
        "nombre_usuario": nombreUsuario,
        "correo_usuario": correo_usuario,
        "direccion": direccion,
        "tipo_plan": tipoPlan,
        "claveAcceso": claveAcceso,
        "id_cliente": id_cliente,
        "bolsa": bolsa,
        "tipo_usuario": tipo_usuario
      };
}
