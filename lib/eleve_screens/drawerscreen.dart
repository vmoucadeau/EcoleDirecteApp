import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecoledirecte/api.dart';

import 'homescreen.dart';
import 'agendascreen.dart';
import 'notescreen.dart';

List<Map> studentDrawerItems = [
  {
    'icon': FontAwesomeIcons.home,
    'title': 'Accueil',
    'selected': true,
  },
  {
    'icon': FontAwesomeIcons.barcode,
    'title': 'Badge cantine',
    'selected': false
  },
  {'icon': FontAwesomeIcons.stamp, 'title': 'Vie scolaire', 'selected': false},
  {
    'icon': FontAwesomeIcons.graduationCap,
    'title': 'Notes',
    'selected': false,
  },
  {'icon': FontAwesomeIcons.envelope, 'title': 'Messagerie', 'selected': false},
  {
    'icon': FontAwesomeIcons.calendarAlt,
    'title': 'Emploi du temps',
    'selected': false
  },
  {
    'icon': FontAwesomeIcons.book,
    'title': 'Cahier de texte',
    'selected': false
  },
  {'icon': FontAwesomeIcons.folder, 'title': 'Documents', 'selected': false}
];

class DrawerScreen extends StatefulWidget {
  final Session eleve_session;
  DrawerScreen({Key key, @required this.eleve_session}) : super(key: key);
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    Eleve eleve = Eleve.fromSession(widget.eleve_session);
    return Container(
      padding: EdgeInsets.only(
          top: padding.top + 10, left: 15, bottom: padding.bottom + 20),
      color: Colors.blueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                  // backgroundImage: NetworkImage(eleve.picturl),
                  ),
              new Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eleve.prenom + " " + eleve.nom + " " + eleve.classe,
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w400))),
                  Text(
                    "Compte élève",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              )
            ],
          ),
          Column(
            children: studentDrawerItems
                .map((element) => Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: GestureDetector(
                        onTap: () {
                          print("Element : " + element['title']);
                          setState(() {
                            studentDrawerItems.forEach((element2) {
                              if (element2['selected']) {
                                if (element["title"] != element2["title"]) {
                                  element2['selected'] = false;
                                  element['selected'] = true;

                                  if (element["title"] == "Notes") {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => NotesPage(eleve_session: eleve.session,)));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NotesPage(
                                                  eleve_session: eleve.session,
                                                )),
                                        (route) => false);
                                  }
                                  if (element["title"] == "Accueil") {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => NotesPage(eleve_session: eleve.session,)));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                  eleve_session: eleve.session,
                                                )),
                                        (route) => false);
                                  }
                                }
                              }
                            });
                          });
                        },
                        child: Row(
                          children: [
                            FaIcon(
                              element['icon'],
                              color: element['selected']
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.7),
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(element['title'],
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: element['selected']
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.7))))
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          Row(
            children: [
              Icon(Icons.settings, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text("Paramètres",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white))),
              SizedBox(
                width: 10,
              ),
              Container(width: 2, height: 20, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              FaIcon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Se déconnecter",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white))),
            ],
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Session eleve_session;

  HomePage({Key key, @required this.eleve_session}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        DrawerScreen(
          eleve_session: eleve_session,
        ),
        HomeScreen(
          eleve_session: eleve_session,
        )
      ],
    ));
  }
}


class NotesPage extends StatelessWidget {
  final Session eleve_session;

  NotesPage({Key key, @required this.eleve_session}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        DrawerScreen(
          eleve_session: eleve_session,
        ),
        NotesScreen(
          eleve_session: eleve_session,
        )
      ],
    ));
  }
}
