import 'package:project_fly/src/model/lugar_model.dart';
import 'package:rxdart/rxdart.dart';

class FormulariosBloc{

  final _searchLugarController = BehaviorSubject<Lugar>();
  final _horaController = BehaviorSubject<String>();

  //recuperar los datos del stream
  Stream<Lugar> get lugarStream => _searchLugarController.stream;
  Stream<String> get horaStream => _horaController.stream;

  //insertar valor stream
  Function(Lugar) get changeLugar => _searchLugarController.sink.add;
  Function(String) get changeHora => _horaController.sink.add;

  //valor actual 
  Lugar get lugar => _searchLugarController.value;
  String get hora => _horaController.value;

  //cierra flujo
  dispose(){
    _searchLugarController?.close();
    _horaController?.close();
  }
}