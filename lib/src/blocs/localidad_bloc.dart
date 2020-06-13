import 'package:project_fly/src/model/evento_model.dart';
import 'package:project_fly/src/model/localidad_model.dart';
import 'package:rxdart/rxdart.dart';

class LocalidadBloc{

  final _localidadController = BehaviorSubject<Localidad>();
  final _localidadesController = BehaviorSubject<List<Localidad>>();

  //recuperar los datos del stream
  Stream<Localidad> get localidadStream => _localidadController.stream;
  Stream<List<Localidad>> get localidadesStream => _localidadesController.stream;

  //insertar valor stream
  Function(Localidad) get changeLocalidad => _localidadController.sink.add;
  Function(List<Localidad>) get changeLocalidades => _localidadesController.sink.add;

  //Añade Evento a localidadStream
  void addEvento(Evento evento){
    Localidad localidad = _localidadController.value;
    localidad.eventos.add(evento);
    _localidadController.sink.add(localidad);
  }


  //valor actual 
  Localidad get localidad => _localidadController.value;
  List<Localidad> get localidades => _localidadesController.value;

  //cierra flujo
  dispose(){
    _localidadController?.close();
    _localidadesController?.close();
  }
}
