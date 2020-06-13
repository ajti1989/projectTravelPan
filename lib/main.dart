import 'package:flutter/material.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/pages/crear_evento_page.dart';
import 'package:project_fly/src/pages/crear_lugar_page.dart';
import 'package:project_fly/src/pages/dia_page.dart';
import 'package:project_fly/src/pages/home_page.dart';
import 'package:project_fly/src/pages/login_page.dart';
import 'package:project_fly/src/pages/map_page.dart';
import 'package:project_fly/src/pages/new_viaje_page.dart';
import 'package:project_fly/src/pages/register_page.dart';
import 'package:project_fly/src/pages/viaje_page.dart';
import 'package:project_fly/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
 
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

 runApp(MyApp());

}
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context)  {

  
 
    
    return Provider(
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en','US'), // Inglés
          const Locale('es','ES'), // Español
        ],
        debugShowCheckedModeBanner: false,
        title: 'PlainVoyager',
        initialRoute: 'login',
        routes: {
          'login' : (BuildContext context) => LoginPage(),
          'register' : (BuildContext context) => RegisterPage(),
          'home' : (BuildContext context) => HomePage(),
          'nuevoViaje' : (BuildContext context) => NewViajePage(),
          'viaje' : (BuildContext context) => ViajePage(),
          'dia' : (BuildContext context) => DiaPage(),
          'crearLugar' : (BuildContext context) => CrearLugar(),
          'crearEvento' : (BuildContext context) => CrearEvento(),
          'mapa' : (BuildContext context) => MapPage(),
        },
        builder: (context, child) =>
          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
      ),
    );
    
    
    
  }
}