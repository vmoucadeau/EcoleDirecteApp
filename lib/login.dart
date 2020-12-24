import 'package:ecoledirecte/eleve_screens/homescreen.dart';
import 'package:ecoledirecte/eleve_screens/drawerscreen.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'api.dart';


class ElevePage extends StatelessWidget {
  final Session eleve_session;

  ElevePage({Key key, @required this.eleve_session}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [DrawerScreen(eleve_session: eleve_session,), HomeScreen(eleve_session: eleve_session,)],
    ));
  }
}

Future<Session> doedlogin() async {
  final storage = new FlutterSecureStorage();
  String identifiant = await storage.read(key: "ed_identifiant");
  String mdp = await storage.read(key: "ed_password");
  if (identifiant.isEmpty || mdp.isEmpty) {
    return null;
  }
  final Session edsession = await edlogin(identifiant, mdp);
  return edsession;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String identifiant;
  String password;

  final _loginform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome to Flutter",
        home: new Material(
            color: Colors.white,
            child: SingleChildScrollView(
              child: new Container(
                  padding: const EdgeInsets.all(20.0),
                  // color: Colors.white,
                  child: new Container(
                    child: new Center(
                        child: new Column(children: [
                      new Padding(padding: EdgeInsets.only(top: 40.0)),
                      new Text('EcoleDirecte',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: hexToColor("#0F8DCF"), fontSize: 35))),
                      new Text('Connexion',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: hexToColor("#F2A03D"), fontSize: 20))),
                      new Padding(padding: EdgeInsets.only(top: 50.0)),
                      Form(
                        key: _loginform,
                        child: Column(
                          children: [
                            new TextFormField(
                              decoration: new InputDecoration(
                                icon: FaIcon(FontAwesomeIcons.solidUser),
                                labelText: "Identifiant",
                                fillColor: Colors.white,
                                labelStyle:
                                    GoogleFonts.montserrat(fontSize: 16),

                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Veuillez saisir votre identifiant.";
                                } else {
                                  identifiant = val;
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.montserrat(fontSize: 16),
                            ),
                            new Padding(padding: EdgeInsets.only(top: 20.0)),
                            new TextFormField(
                              obscureText: true,
                              decoration: new InputDecoration(
                                icon: FaIcon(FontAwesomeIcons.lock),
                                labelText: "Mot de passe",
                                labelStyle:
                                    GoogleFonts.montserrat(fontSize: 16),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Veuillez saisir votre mot de passe.";
                                } else {
                                  password = val;
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.visiblePassword,
                              style: GoogleFonts.montserrat(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      new Padding(padding: EdgeInsets.only(top: 40.0)),
                      OutlineButton(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 15, right: 15),
                          child: new Text("Se connecter",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 18, color: Colors.black))),
                          onPressed: () async {
                            final storage = new FlutterSecureStorage();

                            if (_loginform.currentState.validate()) {
                              FocusScope.of(context).unfocus();

                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Connexion en cours..."), duration: Duration(seconds: 1),));
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              await storage.deleteAll();
                              await storage.write(
                                  key: "ed_identifiant", value: identifiant);
                              await storage.write(
                                  key: "ed_password", value: password);

                              final Session edsession = await doedlogin();
                              if (edsession.typecompte == null) {
                                showGeneralDialog(
                                    barrierColor: Colors.black.withOpacity(0.2),
                                    transitionBuilder:
                                        (context, a1, a2, widget) {
                                      return Transform.scale(
                                        scale: a1.value,
                                        child: Opacity(
                                          opacity: a1.value,
                                          child: AlertDialog(
                                            shape: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            title: Text(
                                              'Erreur',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            content: Text(
                                              'Identifiant ou mot de passe incorrect',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    transitionDuration:
                                        Duration(milliseconds: 400),
                                    barrierDismissible: true,
                                    barrierLabel: '',
                                    context: context,
                                    pageBuilder:
                                        (context, animation1, animation2) {});
                              } else {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ElevePage(eleve_session: edsession,)), (Route<dynamic> route) => false);
                              }
                            }
                          },
                          shape: new RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: new BorderRadius.circular(30.0),
                          )),
                    ])),
                  )),
            )));
  }
}
