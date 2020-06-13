import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/src/blocs/dia_bloc.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/model/localidad_model.dart';
import 'package:project_fly/src/providers/go_place_provider.dart';
import 'package:project_fly/src/providers/viaje_provider.dart';

class SearchLocalidad extends SearchDelegate{
  
  GoPlaceProvider goPlaceProvider = GoPlaceProvider();
  ViajeProvider viajeProvider = ViajeProvider();
  
  

  // Las acciones de nuestro APPBar
  @override
  List<Widget> buildActions(BuildContext context) {
    
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: (){
          query = '';
        }
      ),
    ];
  }

  // icono a la izquierda del appbar
  @override
  Widget buildLeading(BuildContext context) {
    
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation
      ), 
      onPressed: (){
        close(
          context, null
        );
      }
    );
  }

  // Crea resultados
  @override
  Widget buildResults(BuildContext context) {
    query = 'hkh';
    return Container();
  }

  // sugerencias aparecen cuando el usuario escribe
  @override
  Widget buildSuggestions(BuildContext context) {

    ViajesBloc viajesBloc = Provider.viajesBloc(context);
    DiaBloc diaBloc = Provider.diaBloc(context);

     if(query.isEmpty){
      return Container();
    }else{

    return FutureBuilder (
        future: goPlaceProvider.autoComplete(query),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String,String>>> snapshot) { 
          if(snapshot.hasData != null){
            return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {  
              Map<String, String> sitio = snapshot.data[index];
              
              return ListTile(
                title: Text(sitio['name']),
                subtitle: Text(sitio['descripcion']),                
                leading: Icon(Icons.place),

                onTap: () async {
                 
                  Localidad localidad = await goPlaceProvider.localidadId(sitio['idPlace']);
                  DocumentReference refDia = Firestore.instance.collection('travels')
                  .document(viajesBloc.viaje.idViaje).collection('dias')
                  .document(diaBloc.dia.idDia);

                  await viajeProvider.crearLocalidad(refDia, localidad); 

                  // diaBloc.addLocalidad(localidad);
                  diaBloc.cargarDia(refDia);

                  Navigator.of(context).maybePop();
                }
              );
            },  
          );
          }else{

            return Container(
              child: Center(
                child: Text('cargando'),
              ),
            );

          }
          
         },  
      );
    }
  }

}