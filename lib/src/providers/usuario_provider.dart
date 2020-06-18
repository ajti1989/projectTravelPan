import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'package:project_fly/src/model/usuario_model.dart';
import 'package:project_fly/src/preferencias_usuario/preferencias_usuario.dart';

class UsuarioProvider{

  final String _firebaseToken = 'AIzaSyCgeusmPcvK4MqjH6YwSBKHQN8nByVHsQk';
  final _prefs = new PreferenciasUsuario();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ////// API REST //////
  //Crear Usuario por correo email api rest
  Future register(String email, String password) async{


    //datos de usuario
    final authData = {
      'email': email,
      'password' : password,
      'returnSecureToken' : true
    };

    //Solicitud de datos a Firebase
    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

     if(decodedResp.containsKey('idToken')){
      _prefs.token = decodedResp['idToken'];
      _prefs.email = decodedResp['email'];
      _prefs.uid = decodedResp['localId'];

      return {'ok': true, 'token': decodedResp['idToken']};
      
    }else{
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }

  }

  //login api rest
  Future login( String email, String password ) async{

    final authData = {
      'email' : email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    if(decodedResp.containsKey('idToken')){

      _prefs.token =  decodedResp['idToken'];
      _prefs.email = decodedResp['email'];
      _prefs.uid = decodedResp['localId'];

      return {'ok': true, 'token': decodedResp['idToken']};
    }else{
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }

  }



/////  Authentication /////
///
///
  Future<FirebaseUser> loginEmail(String email, String password) async {
  
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      _prefs.email = user.email;
      _prefs.uid = user.uid;
      user.getIdToken().then((value) {
        _prefs.token = value.token; 
      });

      return user;
    }catch(e){
      print(e);
      return null;
    }
  }

  //Registro usuario con AuthFirebase
  Future<FirebaseUser> registerEmail(email, password) async {

    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = result.user;

    assert (user != null);
    assert (await user.getIdToken() != null);

    return user;

  } 

  // iniciar sesion con google
  Future loginGoogle() async{

    //Login con google y comprueba la autenticacion
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  
  //Captura las credenciales de google
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //utiliza las credenciales para loguerarse o registrarse si no lo está en firebase 
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    if (user != null){
        //guarda info usuario en preferencias de app
      _prefs.email = user.email;
      _prefs.uid = user.uid;
      
      user.getIdToken().then((value) {
        _prefs.token = value.token; 
      });
      return {'ok': true};
    }else{
      return {'ok': false, 'mensaje': 'Upps tenemos un problema'};
    }
  }

//estado del usuario
Future<FirebaseUser> getCurrentUser() async {
  
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  
    if (user != null) {
      return user;
    } else {
      return null;
    }
}

void logOut(){
  _prefs.token = '';
  _prefs.email = '';
  _prefs.uid = '';
}
  
Future<void> singnOut(){
  _prefs.token = '';
  _prefs.email = '';
  _prefs.uid = '';
  return FirebaseAuth.instance.signOut();
}


}