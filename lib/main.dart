import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:informes_maat_movil/service/push_notification_service.dart';
import 'package:informes_maat_movil/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        //const Locale('en', ''), // English, no country code
        const Locale('es', 'ES'), // Hebrew, no country code

        // ... other locales the app supports
      ],
      title: 'MAATInformes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Nunito',
      ),
      /*
      darkTheme: ThemeData(
        //Se indica que el tema tiene un brillo oscuro
        brightness: Brightness.dark,
        primarySwatch: Colors.lightBlue,
      ),*/
      home: Splas_ini(),
    );
  }
}
