import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_fly/src/model/evento_model.dart';
import 'package:project_fly/src/providers/viaje_provider.dart';
import 'package:rxdart/rxdart.dart';

class EventoBloc{

  final _eventoController = BehaviorSubject<Evento>();
  final _eventosController = BehaviorSubject<List<Evento>>();

  final _viajesProvider = ViajeProvider();
  // final _eventoController = BehaviorSubject<Evento>();

  //valor actual 
  Evento get evento => _eventoController.value;
  List<Evento> get eventos => _eventosController.value;

  //recuperar los datos del stream
  Stream<List<Evento>> get eventosStream => _eventosController.stream;


  //insertar  valor stream
  Function(Evento) get changeEvento => _eventoController.sink.add;
  Function(List<Evento>) get changeEventos => _eventosController.sink.add;

  void crearEvento(DocumentReference refLocalidad, Evento evento ) async {
    await _viajesProvider.crearEvento(refLocalidad, evento);
  }

  //elimnar evento
  //elimanar un lugar
  void borrarEvento (DocumentReference evento ) async => await _viajesProvider.eliminarDocumento(evento);

  void addEvento(Evento evento){
    List<Evento> eventos = _eventosController.value;
    eventos.add(evento);
    changeEventos(eventos);
  }
 

      
  //cierra flujo
  dispose(){
    _eventoController?.close();
    _eventosController?.close();
  }
    
}
