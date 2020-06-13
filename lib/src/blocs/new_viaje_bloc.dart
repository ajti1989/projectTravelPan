import 'package:project_fly/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class NewViajeBloc with Validators{

  final _dateIniController = BehaviorSubject<DateTime>();
  final _dateEndController = BehaviorSubject<DateTime>();

  //recuperar los datos del stream
  Stream<DateTime> get dateIniStream => _dateIniController.stream;
  Stream<DateTime> get dateEndStream => _dateEndController.stream;

  //insertar valor stream
  Function(DateTime) get changeDateIni => _dateIniController.sink.add;
  Function(DateTime) get changeDateEnd => _dateEndController.sink.add;

  //valor actual 
  DateTime get dateIni => _dateIniController.value;
  DateTime get dateEnd => _dateEndController.value;

  //cierra flujo
  dispose(){
    _dateIniController?.close();
    _dateEndController?.close();
  }
}
