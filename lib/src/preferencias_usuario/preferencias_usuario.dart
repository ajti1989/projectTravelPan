import 'package:shared_preferences/shared_preferences.dart';



class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }

  get uid {
    return _prefs.getString('uid') ?? '';
  }

  set uid( String value ){
    _prefs.setString('uid', value);
  }

  get email {
    return _prefs.getString('email') ?? '';
  }

  set email( String value ){
    _prefs.setString('email', value);
  }

  

  // GET y SET de la última página
  // get ultimaPagina {
  //   return _prefs.getString('ultimaPagina') ?? 'login';
  // }

  // set ultimaPagina( String value ) {
  //   _prefs.setString('ultimaPagina', value);
  // }

}