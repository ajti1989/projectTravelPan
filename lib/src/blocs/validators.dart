import 'dart:async';

class Validators{


  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){

      if(password.length >= 6){
        sink.add(password);
      }else{
        sink.addError('Longitud minima de 6 caracteres');
      }

    }
  );
  
  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);

      if( regExp.hasMatch( email ) ){
        sink.add(email);
      }else{
        sink.addError('Introduce un email correcto');
      }

    }
  );

  final validarFecha = StreamTransformer<String, String>.fromHandlers(
    handleData: (date, sink){

      Pattern pattern = r'^([0-9]{2}-[0-9]{2}-[0-9]{4})$';
      RegExp regExp = new RegExp(pattern);

      if( regExp.hasMatch( date ) ){
        sink.add(date);
      }else{
        sink.addError('Introduce una fecha correcta');
      }
     

    }

  );

  



}