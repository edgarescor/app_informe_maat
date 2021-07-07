import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:informes_maat_movil/system/provaider/db_provaider.dart';

class Push_notification_service {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<Map> _data = new StreamController.broadcast();
  static Stream<Map> get mensajesStream => _data.stream;
  /** para el titulo de la notificacion */
  static StreamController<String> _titulo = new StreamController.broadcast();
  static Stream<String> get titulo_mensaje => _titulo.stream;

  static Future _onbackgrounHandler(RemoteMessage message) async {
    //print("on back ground handler ${message.messageId}");
    _titulo.add(message.notification?.title ?? "no hay titulo");
    _data.add(message.data);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print("on messsage handler ${message.messageId}");
    _titulo.add(message.notification?.title ?? "no hay titulo");
    _data.add(message.data);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    _titulo.add(message.notification?.title ?? "no hay titulo");
    _data.add(message.data);
  }

  static Future inicialApp() async {
    // pus notificaciones optener el token del dispositivo
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    DBprovaider.db.addToken(token!);

    //handlers
    FirebaseMessaging.onBackgroundMessage(_onbackgrounHandler);

    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    //local notificaciones
  }

  static close() {
    _data.close();
    _titulo.close();
  }
}
