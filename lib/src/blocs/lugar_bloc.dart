import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_fly/src/model/lugar_model.dart';
import 'package:project_fly/src/providers/viaje_provider.dart';
import 'package:rxdart/rxdart.dart';

class LugarBloc{

  final _lugarController = BehaviorSubject<Lugar>();
  final _lugaresController = BehaviorSubject<List<Lugar>>();
  final _viajesProvider = ViajeProvider();


  //valor actual 
  Lugar get lugar => _lugarController.value;
  List<Lugar> get lugares => _lugaresController.value;

  //recuperar los datos del stream
  Stream<List<Lugar>> get lugaresStream => _lugaresController.stream;
  Stream<Lugar> get lugarStream => _lugarController.stream;


  //insertar  valor stream
  Function(Lugar) get changeLugar => _lugarController.sink.add;
  Function(List<Lugar>) get changeLugares => _lugaresController.sink.add;

 
  void crearLugar(DocumentReference refLocalidad, Lugar lugar ) async {
    await _viajesProvider.crearLugar(refLocalidad, lugar);
  }
      
  //cierra flujo
  dispose(){
    _lugarController?.close();
    _lugaresController?.close();
  }
    
}
