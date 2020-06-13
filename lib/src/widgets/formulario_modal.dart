  //esquelo formulario
  import 'package:flutter/material.dart';

  _formEvento(BuildContext context, List<Widget> list, String nombre){
    
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(nombre, style: TextStyle(fontSize: 20),),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            content: SingleChildScrollView(
              child: Container(
                height: 230,
                child: Form(
                  child: Column(
                    children: list,
                  )
                ),
              ),
            ),
              
            actions: <Widget>[
              MaterialButton(
                textColor: Colors.blue,
                elevation: 5.0,
                child:Text('guardar'),
                onPressed: (){
                  Navigator.of(context).pop();
                  }
              )
            ],
          );
        },
      );
  }