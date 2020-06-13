// import 'package:flutter/material.dart';
// import 'package:project_fly/src/model/viaje_model.dart';
// import 'package:project_fly/src/providers/viaje_provider.dart';


// class HomePage extends StatelessWidget {

 
//   final  Viaje viaje1 = new Viaje('Viaje por algún lugar', DateTime.parse('20200701'), DateTime.parse('20200707'));
//   final  Viaje viaje2 = new Viaje('Viaje por otro lugar', DateTime.parse('20200901'), DateTime.parse('20200905'));

//   final List<Viaje> viajes = new List();
  
  

//   @override
//   Widget build(BuildContext context) {
//     viajes.add(viaje1);
//     viajes.add(viaje2);

//     ViajeProvider viajeProvider = new ViajeProvider();

//     viajeProvider.viajesUsuario();


//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Mis viajes'),

//       ),

//       body:  ListView.separated(
//         padding: EdgeInsets.all(10),
//         itemCount: viajes.length,
//         itemBuilder: (BuildContext context, int index) { 
          
//           return ListTile(
//             title: Text('${viajes[index].nombre}', style: TextStyle(fontSize: 20 ),),
//             trailing: Icon(Icons.more_horiz),
//             onTap: () => Navigator.pushNamed(context, 'viaje', arguments: viajes[index]),
          
//           );
//         }, separatorBuilder: (BuildContext context, int index) => const Divider() ,
//       ),

//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: (){
//           Navigator.pushNamed(context, 'nuevoViaje');
         
//         }
//       ),
//     );
//   }

  

 
// }