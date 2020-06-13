import 'package:flutter/material.dart';

Widget dropMenu(context){


    return DropdownButton(
      items: [
        DropdownMenuItem(
        child: Text('Añadir evento'),
        onTap: () {
          print('hola');
          Navigator.of(context).pushNamed('crearEvento');
          } ,
        value: '',
      ),

        DropdownMenuItem(
        child: Text('Añadir Lugar'),
        onTap: () => Navigator.of(context).pushNamed('crearEvento'),
        value: '',
      ),
      ], 
      onChanged: (value) {  },
      icon: Icon(Icons.add_circle_outline),
      underline: Container(),
      autofocus: false,
      

    );
  }