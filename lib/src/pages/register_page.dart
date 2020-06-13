import 'package:flutter/material.dart';
import 'package:project_fly/src/blocs/login_bloc.dart';
import 'package:project_fly/src/blocs/provider.dart';
import 'package:project_fly/src/providers/usuario_provider.dart';
import 'package:project_fly/src/utils/utils.dart';


class RegisterPage extends StatelessWidget {

  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      )
    );
  }

  Widget _crearFondo(BuildContext context){

    final size = MediaQuery.of(context).size;
    

    final fondo =  Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 198, 1.0),
          ]
        )
      ),
    );
    
    final circulo = Container(
      child: Center(
        child: Icon(Icons.business, color: Colors.grey[50], size: 40,),
      ),
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
    
    
    return Stack(
      children: <Widget>[
        fondo,
        Positioned(child: circulo, top: 190.0, left: 30.0),
        Positioned(child: circulo, top: -20.0, left: -20.0),
        Positioned(child: circulo, top: 50.0, right: -10.0),
        Positioned(child: circulo, bottom: 60.0, right: 50.0),
        Positioned(child: circulo, top: 100.0, right: 190.0),

        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 90.0,),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('TravelPlan', style: TextStyle(color: Colors.white, fontSize: 40.0),)
            ],
          ),
        )

      ],
    );
  }

  Widget _loginForm(BuildContext context){

    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    

    return SingleChildScrollView(
      child: Column(

        children: <Widget>[
          SafeArea(
            child: Container(
              height: 210.0,
            )
          ),

          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 1.5
                ),
              ]
            ),
            child: Column(
              children: <Widget>[

                Text('Registro',style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                _crearEmail( bloc ),
                _crearPassword( bloc ),
                SizedBox(height: 20.0,),

                _crearPasswordComp(),
                SizedBox(height: 20.0,),
                _crearBotton( context, bloc )

              ],
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'), 
            child: Text('¿Ya tienes una cuenta?')
          ),
          SizedBox(height: 50.0,)
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0),
          child: TextField(

            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.redAccent,),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo Electrónico',
              errorText:(snapshot.hasError) ? snapshot.error : null, 
            ),
          onChanged: (value) {
            bloc.changeEmail(value); 
          },

          ),
        );
      }
    );
  }

  Widget _crearPassword(LoginBloc bloc){

    return StreamBuilder<Object>(
      stream: bloc.passwordStream,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.redAccent,),
              labelText: 'Password',
              errorText: (snapshot.hasError) ? snapshot.error : null
            ),

          onChanged: (value) => bloc.changePassword(value),
        
            
          ),
        );
      }
    );
 
  }

  _crearPasswordComp(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline, color: Colors.redAccent,),
          labelText: 'Password',
        )
      )
    );
  }


      
  
  Widget _crearBotton(BuildContext context, LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
            child: Text('Registrarse'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          elevation: 0.0,
          textColor: Colors.white,
          color: Colors.deepPurple,
          
          onPressed: ( snapshot.hasData ) ? () => _register(bloc, context) : null,
        );
      }
    ); 
  }


  _register(LoginBloc bloc, BuildContext context) async{

    Map info =  await usuarioProvider.register(bloc.email, bloc.password);

    if(info['ok']){
      Navigator.pushNamed(context, 'home');
    }else{
      mostrarAlerta(context, info['mensaje']);
    }

  }



}