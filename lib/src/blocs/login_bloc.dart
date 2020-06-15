import 'dart:async';

import 'package:project_fly/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

//Controlar lo que se introduzca por los campos del login


class LoginBloc with Validators{

  //BehaviorSubject son Stream vitaminados por la libreria rxdart
  
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _passwordCompController = BehaviorSubject<String>();

  //Recuperar los datos de Stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);
  Stream<String> get passwordCompStream => _passwordCompController.stream.transform(validarPassword)
  .doOnData((value) {
    if(_passwordController.value.compareTo(value) != 0){
      _passwordCompController.addError('Las contraseñas deben de coincidir');
    }
   });
 

  // Comprueba que los campos email y contraseña del formulario login contengan datos
  Stream<bool> get formValidStream => 
    CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);
  
  // Comprueba que todos los campos del formulario register contengan datos
  Stream<bool> get formValidPassStream =>
    CombineLatestStream.combine3(emailStream, passwordStream, passwordCompStream, (a, b, c) => true);
  

  //Insertar valores en el Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeCompPassword => _passwordCompController.sink.add;

  //Obtener ultimo valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get passwordComp => _passwordCompController.value;

  //Cerrar Stream 
  dispose(){
    _emailController?.close();
    _passwordController?.close();
    _passwordCompController?.close();
  }


}