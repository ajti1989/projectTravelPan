import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_fly/src/model/dia_model.dart';
import 'package:project_fly/src/model/localidad_model.dart';
import 'package:project_fly/src/providers/viaje_provider.dart';
import 'package:rxdart/rxdart.dart';

class DiaBloc{

  final _diaController = BehaviorSubject<Dia>();
  final _diasController = BehaviorSubject<List<Dia>>();
  final _viajesProvider = ViajeProvider();
  // final _eventoController = BehaviorSubject<Evento>();

  //valor actual 
  Dia get dia => _diaController.value;
  List<Dia> get dias => _diasController.value;

  //recuperar los datos del stream
  Stream<Dia> get diaStream => _diaController.stream;
  Stream<List<Dia>> get diasStream => _diasController.stream;


  //insertar  valor stream
  Function(Dia) get changeDia => _diaController.sink.add;
  Function(List<Dia>) get changeDias => _diasController.sink.add;


  // cargar dia Stream desde provider
  void cargarDia( DocumentReference refDia ) async {
        _diaController.sink.add(await _viajesProvider.cargaDia(refDia));
      }
    
  //Añade localidad al dia Stream
  void addLocalidad(Localidad localidad){
    Dia dia = _diaController.value;
    dia.localidades.add(localidad);
    _diaController.sink.add(dia);
  }
      
  //cierra flujo
  dispose(){
    _diaController?.close();
    _diasController?.close();
  }
    
}
