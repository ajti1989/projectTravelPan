import 'package:project_fly/src/model/viaje_model.dart';
import 'package:project_fly/src/providers/viaje_provider.dart';
import 'package:rxdart/rxdart.dart';

class ViajesBloc {

  final _viajesProvider      = new ViajeProvider();

  final _viajesController    = new BehaviorSubject<List<Viaje>>();
  final _cargandoController  = new BehaviorSubject<bool>();
  final _viajeController     = new BehaviorSubject<Viaje>();


  
  Stream<List<Viaje>> get viajesStream => _viajesController.stream;
  Stream<bool> get cargandoStream      => _cargandoController.stream;
  Stream<Viaje> get viajeStream        => _viajeController.stream;
  
  
  /////////// CARGAS ////////////

  Future<Null> cargarviajes() async {
    final viajes = await _viajesProvider.viajesUsuario();
    _viajesController.sink.add( viajes );
  }

  //carga viaje a Stream por firebase
  void cargarViajeId( String idViaje ) async {
     _cargandoController.sink.add(true);
    final viaje = await _viajesProvider.cargarViajeId(idViaje);
    _viajeController.sink.add(viaje);
    _cargandoController.sink.add(false);
    
  }

  ///Cargar viaje a Stream 
  Function(Viaje) get changeViaje => _viajeController.sink.add;

  /////// CREACIÓN ///////////

  void crearViaje( Viaje viaje ) async {
    _cargandoController.sink.add(true);
    await _viajesProvider.crearViaje(viaje);
    _cargandoController.sink.add(false);
  }
 
  
  

  ///// EDITAR ////////
  void editarViaje( String id, Viaje viaje ) async {
    _cargandoController.sink.add(true);
    await _viajesProvider.editarViaje( id, viaje );
    _cargandoController.sink.add(false);
  }


  ///////// ELIMINAR /////////
  
  void borrarViaje( String id ) async => await _viajesProvider.eliminarViaje(id);





  //GETTERS

  Viaje get viaje => _viajeController.value;
  bool get cargando => _cargandoController.value;
  List<Viaje> get viajes => _viajesController.value;
  
  dispose() {
    _viajesController?.close();
    _viajeController?.close();
    _cargandoController?.close();
  }

}