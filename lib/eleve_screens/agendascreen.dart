import 'package:ecoledirecte/api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AgendaScreen extends StatefulWidget {
  final Session eleve_session;
  AgendaScreen({Key key, @required this.eleve_session}) : super(key: key);
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  @override
  double xOffset = 0;
  double yOffset = 0;
  double scalefactor = 1;

  bool isDrawerOpen = false;

  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    Eleve eleve = Eleve.fromSession(widget.eleve_session);
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

    double appbaropacity = 1;

    void TriggerDrawer() {
      isDrawerOpen
          ? setState(() {
              xOffset = 0;
              yOffset = 0;
              scalefactor = 1;
              isDrawerOpen = false;
            })
          : setState(() {
              xOffset = MediaQuery.of(context).size.width / 2 + 50;
              yOffset = height1 / 2 - (height / 2 * 0.6);
              scalefactor = 0.6;
              isDrawerOpen = true;
            });
    }

    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scalefactor),
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius:
            isDrawerOpen ? BorderRadius.circular(35) : BorderRadius.circular(0),
        boxShadow: isDrawerOpen
            ? [
                new BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 0),
                    blurRadius: 30,
                    spreadRadius: 3)
              ]
            : [],
      ),
      child: Column(
        children: [
          SizedBox(height: 0),
          // TopBar(isDrawerOpen: isDrawerOpen,)

          AnimatedOpacity(
            duration: Duration(milliseconds: 1000),
            opacity: 1,
            curve: Curves.fastOutSlowIn,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.only(
                  left: 15, right: 15, top: padding.top + 20, bottom: 15),
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: isDrawerOpen
                          ? FaIcon(FontAwesomeIcons.times)
                          : FaIcon(FontAwesomeIcons.bars),
                      onPressed: () {
                        TriggerDrawer();
                      }),
                  Column(
                    children: [
                      Text("Mon EcoleDirecte",
                          style: GoogleFonts.montserrat(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              color: hexToColor("#0F8DCF"))),
                      Text("Cahier de texte",
                          style: GoogleFonts.montserrat(
                              fontSize: 20, color: hexToColor("#F2A03D")))
                    ],
                  ),
                  CircleAvatar(backgroundColor: Colors.blue)
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: eleve.FetchCahierDeTexte(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> result = snapshot.data;

                return Text("coucou");
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
