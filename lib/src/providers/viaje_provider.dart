import 'package:project_fly/src/model/dia_model.dart';
import 'package:project_fly/src/model/evento_model.dart';
import 'package:project_fly/src/model/localidad_model.dart';
import 'package:project_fly/src/model/lugar_model.dart';
import 'package:project_fly/src/model/viaje_model.dart';
import 'package:project_fly/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViajeProvider {

  // final String _url = 'https://travelplan-65c51.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  // Crea un viaje en Firestore
  Future<bool> crearViaje( Viaje viaje ) async {

      String idViaje = '';

    CollectionReference viajesUsuario = Firestore.instance
    .collection('travelsUser')
    .document(_prefs.uid)
    .collection('travels');

    await Firestore.instance
    .collection('travels').add(
      viaje.toJson()
    ).then((value) {
      viajesUsuario.document(value.documentID).setData(viaje.toJson());
      idViaje = value.documentID;
    }).catchError((error) => print('$error algo ha pasado UPPPSS!!!'))
      .whenComplete(() => print('todo correcto')
    );

    DocumentReference dia =  Firestore.instance
    .collection('travels').document(idViaje);

    _crearDias(dia, viaje.dias);

    return true;
  }


  // carga todos los viajes del usuario logueado
  Future<List<Viaje>> viajesUsuario() async {

    List<Viaje> viajes = List();

    CollectionReference viajesUsuario = Firestore.instance
      .collection('travelsUser')
      .document(_prefs.uid)
      .collection('travels');

    await viajesUsuario.getDocuments().then((value) =>
      value.documents.forEach((element){
        Viaje viaje = new Viaje.provider(element.data);
        viaje.idViaje = element.documentID;
        viajes.add(viaje);
      })).catchError((error) => print(error));

    return viajes;    
  }

  //Elimina un viaje específico
  Future<bool> eliminarViaje( String idViaje ) async{

     CollectionReference viajesUsuario = Firestore.instance
      .collection('travelsUser')
      .document(_prefs.uid)
      .collection('travels');

    await viajesUsuario.document(idViaje).delete()
      .catchError((error){
        print(error);
        return false;
      });

    return true;
  }

  //edita un viaje 
  Future<bool> editarViaje( String idViaje, Viaje viaje ) async {
     CollectionReference viajesUsuario = Firestore.instance
      .collection('travelsUser')
      .document(_prefs.uid)
      .collection('travels');

    await Firestore.instance
    .collection('travels').document(idViaje).setData(
      viaje.toJson())
        .then((value) {
          viajesUsuario.document(idViaje).setData(viaje.toJson());
        })
        .catchError((error) => print('$error algo ha pasado UPPPSS!!!'))
        .then((value) => print('$value todo correcto'));

    return true;
  }



  //Cargar viaje completo por id
  Future<Viaje> cargarViajeId(String idViaje) async {

    Viaje viaje;  
    
    DocumentReference viajeUsuario = Firestore.instance
      .collection('travels')
      .document(idViaje);
      
      //Carga viaje
      await viajeUsuario.get().then((value) {
        viaje = Viaje.provider(value.data);
        viaje.idViaje = idViaje;
        }).catchError((error) => print('$error'));
       
      //Carga de dias
      await viajeUsuario.collection('dias').orderBy("dia").getDocuments().then((value) 
        => value.documents.forEach((element) {
          Dia dia = Dia.provider(element.data);
          dia.idDia = element.documentID;
          viaje.dias.add(dia);
        })).catchError((error) => print('$error'));


      for (var dia in viaje.dias) {
        await viajeUsuario.collection('dias').document(dia.idDia)
          .collection('localidades').getDocuments().then((value) 
            => value.documents.forEach((element){ 
              Localidad localidad = Localidad.provider(element.data);
              localidad.idLocalidad = element.documentID;
              dia.localidades.add(localidad);     
            })
          ).catchError((error) => print(error));
      }

      

      // carga eventos
      for (var dia in viaje.dias) {
        for(var localidad in dia.localidades)  {
          await  viajeUsuario.collection('dias').document(dia.idDia)
          .collection('localidades').document(localidad.idLocalidad)
          .collection('eventos').getDocuments().then((value) 
            => value.documents.forEach((element) {
              Evento evento = Evento.provider(element.data);
              evento.idEvento = element.documentID;
              localidad.eventos.add(evento);
            })
          ).catchError((error) => print(error));
        }
      }
      
      // //carga lugares
      for (var dia in viaje.dias) {
        for(var localidad in dia.localidades)  {
          await  viajeUsuario.collection('dias').document(dia.idDia)
          .collection('localidades').document(localidad.idLocalidad)
          .collection('lugares').getDocuments().then((value) 
            => value.documents.forEach((element) {
              Lugar lugar = Lugar.provider(element.data);
              lugar.idLugar = element.documentID;
              localidad.lugares.add(lugar);
            })
          ).catchError((error) => print(error));
        }
      } 

    return viaje;   
  }

  //Carga un dia referenciando un dia
  Future<Dia> cargaDia(DocumentReference refDia) async {
    Dia dia;

    await refDia.get()
    .then((value){
      dia = Dia.provider(value.data);
      dia.idDia = value.documentID;
    });
    
    await refDia.collection('localidades').getDocuments().then((value) 
      => value.documents.forEach((element){ 
        Localidad localidad = Localidad.provider(element.data);
        localidad.idLocalidad = element.documentID;
        dia.localidades.add(localidad);     
      })
  ).catchError((error) => print(error));
      
      // carga eventos
        for(var localidad in dia.localidades)  {
          await  refDia
          .collection('localidades').document(localidad.idLocalidad)
          .collection('eventos').getDocuments().then((value) 
            => value.documents.forEach((element) {
              Evento evento = Evento.provider(element.data);
              evento.idEvento = element.documentID;
              localidad.eventos.add(evento);
            })
          ).catchError((error) => print(error));
        }
      
      
      // //carga lugares
   
        for(var localidad in dia.localidades)  {
          await refDia
          .collection('localidades').document(localidad.idLocalidad)
          .collection('lugares').getDocuments().then((value) 
            => value.documents.forEach((element) {
              Lugar lugar = Lugar.provider(element.data);
              lugar.idLugar = element.documentID;
              localidad.lugares.add(lugar);
            })
          ).catchError((error) => print(error));
        }
      

    return dia;   
  }

  //Crea una Localidad refenciando a un dia
  Future<Dia> crearLocalidad(DocumentReference refDia, Localidad localidad) async{

    Dia dia;

    await refDia.collection('localidades').document().setData(localidad.toJson())
    .catchError((error) => print('$error algo ha pasao con la localidad'))
    .whenComplete(() => print('aqui llego'));

    await refDia.get().then((element) {
    dia = Dia.provider(element.data);
    dia.idDia = element.documentID;});

    return dia;

  }

  //Crea dias referenciando a un viaje
  Future<bool> _crearDias(DocumentReference refViaje, List<Dia> dias ) async{

    for (var dia in dias) {
      await refViaje.collection('dias').document().setData(dia.toJson())
      .catchError((error) => print(error))
      .whenComplete(() => print('aqui llega'));
    }
    return true;
  }

  //Crea un Evento referenciando a una localidad
  Future<bool> crearEvento(DocumentReference refLocalidad, Evento evento) async{

    refLocalidad.collection('eventos').document().setData(evento.toJson())
    .catchError((error) => print(error))
    .whenComplete(() => print('terminó'));
  
    return true;
  }

  //Crea un lugar referenciando a una localidad
  Future<bool> crearLugar(DocumentReference refLocalidad, Lugar lugar) async{

    refLocalidad.collection('lugares').document().setData(lugar.toJson())
    .catchError((error) => print(error))
    .whenComplete(() => print('terminó'));
  
    return true;
  }

  }

  




