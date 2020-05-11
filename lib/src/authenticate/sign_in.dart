import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:newsport/src/components/theme.dart';
import 'package:newsport/src/services/auth.dart';

class SignIn extends StatefulWidget {

  final Function toogleViews;
  SignIn({ this.toogleViews });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = new AuthService();
  final _formKey = GlobalKey<FormState>();

  String textButton = 'Iniciar sesión';
  bool _obscureText = true;
  String error = '';
  String email = '';
  String password = '';

  void chagedStateIcon(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Colors.white,
        child: Container(
          // height: 75.0,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('¿Aún no tienes cuenta?'),
            FlatButton(
              child: Text('Crear una cuenta'),
              onPressed: () {
                widget.toogleViews();
              },
            ),
           ],
          ),
        ),    
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    color: myTheme.primaryColor,
                    iconSize: 28.0,
                    icon: Icon(Feather.x), onPressed: () => Navigator.popAndPushNamed(context, 'landing')
                  ),
                ),
                SizedBox(height: 70.0,),
                Container(alignment: Alignment.topLeft, child: Text('Inicia sesión',textScaleFactor: 1.7, 
                // style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold )
                )
              ),
                SizedBox(height: 55.0,),
                _loginForm( context ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _createEmail(),
          SizedBox( height: 40.0 ),
          _createPassword(),
          SizedBox(height: 50.0),
          _createButton(),
          SizedBox(height: 30.0),
          // _buttonFacebook(),
          // _customButtons(),
        ],
      ),
    );
  }

    Widget _createEmail(  ) {
   return  Container(
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Ingrese un correo' : null,
        onChanged: (val) {
          setState(() => email = val);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myTheme.primaryColor),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myTheme.primaryColor),
            borderRadius: BorderRadius.circular(5.0)
          ),
          filled: true,
          prefixIcon: Icon( Feather.mail, color: Colors.grey ),
          hintText: 'Ingrese su email',
          labelText: 'Email',
          // labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey)),
          // hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey))
        ),
      ),  
    );
  }

  Widget _createPassword() {
    return Container(
      child: TextFormField(
        validator: (val) => val.length < 6 ? 'La contraseña debe ser mayor a 6 caracteres' : null,
        onChanged: (val) {
          setState(() => password = val);
        },
        obscureText: _obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myTheme.primaryColor),
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myTheme.primaryColor),
            borderRadius: BorderRadius.circular(5.0)
          ),
          filled: true,
          labelText: 'Contraseña',
          // labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey)),
          hintText: 'Ingrese su contraseña',
          // counterText: snapshot.data,
          // hintStyle: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15.0, color: Colors.grey)),
          prefixIcon: _obscureText ? _lockIconClosed() : _lockIconOpen(),
          suffixIcon: IconButton(
            icon: _obscureText ? _iconButtonVisibilityOn() : _iconButtonVisibilityOff(), 
            onPressed:  chagedStateIcon,
          ),                
        ),
      ),
    );
  }

  Widget _createButton() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              onPressed: () async {
                if(_formKey.currentState.validate()){
                  setState(() {
                    textButton = 'Iniciando...';
                  });
                  dynamic result = await _auth.signInWithEmailAndPassword(email, password); 
                  if(result == null) {
                    showDialog(
                    context: context,
                    builder: (context){
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        backgroundColor: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Login', textScaleFactor: 1.2,),
                                  SizedBox(height: 10.0,),
                                  Text('Email o contraseña inválidos.',),
                                  Divider()
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  child: Text('Ok', textScaleFactor: 1.2),
                                  ),
                                )
                              ],
                            )
                          ),
                        );
                      }
                    );
                    setState(() {
                    textButton = 'Iniciar sesión';
                  });
                  }
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
              ),
              color: myTheme.primaryColor,
              textColor: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0),
                child: Text(textButton, textScaleFactor: 1.3 ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _customButtons(){
  //   return FlatButton(
  //     child: Text('¿Olvidaste tu contraseña?', textScaleFactor: 1.0, style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.lightBlueAccent),)),
  //     onPressed: (){
  //     },
  //   );
  // }

  Widget _iconButtonVisibilityOn() => Icon(Feather.eye, color: Colors.grey,);
  Widget _iconButtonVisibilityOff() => Icon(Feather.eye_off, color: Colors.grey,);
  Widget _lockIconClosed() => Icon(Feather.lock, color: Colors.grey,);
  Widget _lockIconOpen()   => Icon(Feather.unlock, color: Colors.grey,);
}