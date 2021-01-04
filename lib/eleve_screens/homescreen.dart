import 'package:ecoledirecte/api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:html/parser.dart';

import 'package:intl/intl.dart';

import 'common_widgets.dart';

class HomeScreen extends StatefulWidget {
  final Session eleve_session;
  HomeScreen({Key key, @required this.eleve_session}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  double xOffset = 0;
  double yOffset = 0;
  double scalefactor = 1;

  bool isDrawerOpen = false;

  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

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

    List<Widget> PageContent = [
      WorkWidget(
        eleve: Eleve.fromSession(widget.eleve_session),
      ),
      SizedBox(
        height: 15,
      ),
      WorkWidget(
        eleve: Eleve.fromSession(widget.eleve_session),
      ),
    ];

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
                      Text("Accueil",
                          style: GoogleFonts.montserrat(
                              fontSize: 20, color: hexToColor("#F2A03D")))
                    ],
                  ),
                  CircleAvatar(backgroundColor: Colors.blue)
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, right: 5, left: 5),
            height: height1 - 120,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(PageContent),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkWidget extends StatefulWidget {
  @override
  final Eleve eleve;

  WorkWidget({Key key, @required this.eleve}) : super(key: key);
  _WorkWidgetState createState() => _WorkWidgetState();
}

class _WorkWidgetState extends State<WorkWidget> {
  @override
  /*
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  List<WorkContainer> _items = [];
  
  Widget sizeIt(BuildContext context, int index, animation) {
    WorkContainer item = _items[index];
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset(0, 0))
          .animate(animation),
      child: item,
    );
  }
  */
  Widget build(BuildContext context) {
    return BaseWidget(
      WidgetIcon: FontAwesomeIcons.book,
      WidgetTitle: "Devoirs pour demain",
      WidgetContent: Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              FutureBuilder(
                future: widget.eleve.GetWorkofDay("2021-01-06"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WorkofDay elevework = snapshot.data;
                    // TODO: Return a container (not a listview) !
                    /*
                      return ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: elevework.works.length,
                        itemBuilder: (context, index) {
                          WorkObj wobj = elevework.works[index];
                          return WorkContainer(
                            work: wobj,
                          );
                        },
                      );
                      */
                    List<WorkContainer> wlist = [];
                    elevework.works.forEach((item) => {
                          wlist.add(WorkContainer(
                            work: item,
                          ))
                        });
                    return Column(
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          direction: Axis.horizontal,
                          children: wlist,
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          )),
    );
  }
}

class WorkContainer extends StatefulWidget {
  @override
  final WorkObj work;

  WorkContainer({Key key, @required this.work}) : super(key: key);
  _WorkContainerState createState() => _WorkContainerState();
}

class _WorkContainerState extends State<WorkContainer> {
  Widget build(BuildContext context) {
    var parsedDate = DateTime.parse(widget.work.donnele);
    List<String> months = [
      "",
      "janvier",
      "février",
      "mars",
      "avril",
      "mai",
      "juin",
      "juillet",
      "août",
      "septembre",
      "octobre",
      "novembre",
      "décembre"
    ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        color: Colors.white,
      ),
      // height: 50,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      widget.work.matiere,
                      style: GoogleFonts.montserrat(fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        widget.work.is_eva
                            ? Container(
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "EVA",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14, color: Colors.white),
                                  textAlign: TextAlign.right,
                                ))
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(6),
                          child: FaIcon(
                            widget.work.is_done
                                ? FontAwesomeIcons.checkCircle
                                : FontAwesomeIcons.timesCircle,
                            color:
                                widget.work.is_done ? Colors.green : Colors.red,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 0, bottom: 10),
                    width: (MediaQuery.of(context).size.width * 0.97) * 0.85,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: parseHtmlString(widget.work.contenu),
                          style: GoogleFonts.montserrat(
                              fontSize: 16, color: Colors.black)),
                    )),
              ],
            ),
            Row(children: [
              Container(
                  width: (MediaQuery.of(context).size.width * 0.97) * 0.85,
                  child: RichText(
                    // overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: "Donné le " +
                            parsedDate.day.toString() +
                            " " +
                            months[parsedDate.month] +
                            widget.work.prof,
                        style: GoogleFonts.montserrat(
                            fontSize: 14, color: Colors.black)),
                  )),
            ])
          ],
        ),
      ),
    );
  }
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}
