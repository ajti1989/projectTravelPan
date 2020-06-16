import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_fly/src/model/lugar_model.dart';
import 'package:project_fly/src/providers/go_place_provider.dart';

class DataSearch extends SearchDelegate{
  
  GoPlaceProvider goPlaceProvider = GoPlaceProvider();
  

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
    query = '';
    return Container();
  }

  // sugerencias aparecen cuando el usuario escribe
  @override
  Widget buildSuggestions(BuildContext context) {
    // final lugarBloc = Provider.lugarBloc(context);

     if(query.isEmpty){
      return Container();
    }else{
      return FutureBuilder (
        future: goPlaceProvider.autoComplete(query),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String,String>>> snapshot) { 
          
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {  
              Map<String, String> sitio = snapshot.data[index];
              
              return ListTile(
                title: Text(sitio['descripcion']),
                leading: Icon(Icons.place),

                onTap: () async {
                  Lugar lugar = new Lugar(sitio['descripcion'], sitio['idPlace'], GeoPoint(0, 1));
                  Lugar lugar1 = await goPlaceProvider.lugarId(lugar.idPlace);
                  // lugarBloc.changeLugar(lugar1);
                  Navigator.of(context).pushReplacementNamed('crearLugar', arguments: lugar1);
                }
              );
            },  
          );
        },  
      );
    }
  }

}