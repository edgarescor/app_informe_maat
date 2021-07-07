import 'dart:io';

import 'package:flutter/material.dart';
import 'package:informes_maat_movil/model/contador_usuarios_model.dart';
import 'package:informes_maat_movil/model/usuarios_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBprovaider {
  static Database? _database;
  static final DBprovaider db = DBprovaider._();
  DBprovaider._();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'MaatDb.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onUpgrade: (Database db, int oldVersion, int newVersion) {
      if (oldVersion < newVersion) {
        /** alter de la version 12 sqlite */ /*
        db.execute("ALTER TABLE Ventas ADD COLUMN tDocumento TEXT ;");
        db.execute("ALTER TABLE Xml ADD COLUMN tDocumento TEXT ;");
        db.execute("ALTER TABLE Usuarios ADD COLUMN codigoAfecto TEXT ;");
        db.execute("ALTER TABLE Usuarios ADD COLUMN CodigoExento TEXT ;");
        db.execute("ALTER TABLE Usuarios ADD COLUMN cajaXpyme TEXT ;");
        db.execute('CREATE TABLE FoliosDupla ('
            'id INTEGER PRIMARY KEY,'
            'folio_inicial TEXT,'
            'folio_final TEXT,'
            'folio_actual TEXT,'
            'fecha_carga TEXT,'
            'uso TEXT,'
            'tDocumento TEXT'
            ')');
        db.execute("ALTER TABLE FoliosDupla ADD COLUMN tDocumento TEXT ;");
        db.execute("ALTER TABLE FoliosDupla ADD COLUMN idXpyme TEXT ;");
        db.execute('CREATE TABLE Folioseleccionado ('
            'id INTEGER PRIMARY KEY,'
            'documento TEXT'
            ')');

        print("object actualizado");*/
      }
    }, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Usuarios ('
          'id INTEGER PRIMARY KEY, '
          'claveAcceso TEXT, '
          'rut TEXT, '
          'dv TEXT, '
          'nombre_usuario TEXT, '
          'correo_usuario TEXT, '
          'direccion TEXT, '
          'tipo_plan TEXT, '
          'id_cliente TEXT, '
          'bolsa TEXT, '
          'tipo_usuario TEXT '
          ')');
      await db.execute('CREATE TABLE Token ('
          'id INTEGER PRIMARY KEY, '
          'token TEXT '
          ')');
    });
  }

  /** funcion que registra los usuarios que se conecten a la app en el dispositivo */
  nuevoUsuario(Usuario nuevoUsuario) async {
    final db = await database;
    final res = await db!.rawInsert(
        "INSERT Into Usuarios (claveAcceso,rut,dv,nombre_usuario,correo_usuario,direccion,tipo_plan,id_cliente,bolsa,tipo_usuario)"
        "VALUES ('${nuevoUsuario.claveAcceso}','${nuevoUsuario.rut}','${nuevoUsuario.dv}','${nuevoUsuario.nombreUsuario}','${nuevoUsuario.correo_usuario}','${nuevoUsuario.direccion}','${nuevoUsuario.tipoPlan}','${nuevoUsuario.id_cliente}','${nuevoUsuario.bolsa}','${nuevoUsuario.tipo_usuario}')");
    print("aqui el registro de la appp $res");
    return res;
  }

  /** buscar la existencia de usuarios en la base de datos de manera que el sistema pueda determinar si exiten datos para el usuario */

  Future<List<ContadorUsuario>> getUsuario() async {
    final db = await database;
    final res = await db!.rawQuery("SELECT COUNT(id) as id FROM Usuarios ");
    //return res.isNotEmpty ? UsuarioXpyme.fromJson(res.first) : null;

    List<ContadorUsuario> listt = res.isNotEmpty
        ? res.map((c) => ContadorUsuario.fromJson(c)).toList()
        : [];
    return listt;
  }

  Future<List<Usuario>> getUsuariofull() async {
    final db = await database;
    final res = await db!.rawQuery("SELECT * FROM Usuarios ");
    //return res.isNotEmpty ? UsuarioXpyme.fromJson(res.first) : null;

    List<Usuario> listt =
        res.isNotEmpty ? res.map((c) => Usuario.fromJson(c)).toList() : [];
    return listt;
  }

  /** agregar token del equipo */
  addToken(String token) async {
    int verificador = await existenciaToken(token);
    if (verificador == 0) {
      final db = await database;
      final res =
          await db!.rawInsert("INSERT Into Token (token) VALUES('$token')");

      print("el token se registro con exito");
    } else {
      print("token ya existe");
    }
  }

  existenciaToken(String token) async {
    final db = await database;
    final res = await db!.rawQuery(
        "SELECT COUNT(id) as verificar From Token where token='$token'");
    if (res[0]['verificar'] == 0) {
      final eliminar = await db.rawDelete("DELETE from Token");
      return 0;
    } else {
      return 1;
    }
  }

  /**reset de la base de datos */
  eliminartodo() async {
    final db = await database;
    final usuarios = await db!.rawDelete("DELETE from Usuarios");
    final token = await db.rawDelete("DELETE from Token");
    print("se elimino el usuario $usuarios");
    print("se elimino el usuario $token");
  }

  /** datos del usuario registrado */
  datosUsuarioConectado() async {
    final db = await database;
    final res = await db!.rawQuery("SELECT * from Usuarios");
    return res;
  }

  gettoken() async {
    final db = await database;
    final res = await db!.rawQuery("SELECT token from Token");
    return res[0]['token'];
  }

  dataUsuario() async {
    final db = await database;
    final res = await db!.rawQuery("SELECT * FROM Usuarios ");
    return res;
  }
}
