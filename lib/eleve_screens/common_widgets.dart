import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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

List<String> days = [
  "",
  "Lundi",
  "Mardi",
  "Mercredi",
  "Jeudi",
  "Vendredi",
  "Samedi",
  "Dimanche"
];

class BaseWidget extends StatefulWidget {
  @override
  final IconData WidgetIcon;
  final String WidgetTitle;
  final Container WidgetContent;
  final bool ShowIcon;

  BaseWidget(
      {Key key,
      this.WidgetIcon,
      @required this.WidgetTitle,
      @required this.WidgetContent,
      this.ShowIcon = true})
      : super(key: key);
  _BaseWidgetState createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      // margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.97,
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                widget.ShowIcon ? FaIcon(widget.WidgetIcon) : SizedBox(),
                Text(
                  " " + widget.WidgetTitle,
                  style: GoogleFonts.montserrat(fontSize: 24),
                )
              ],
            ),
            widget.WidgetContent
          ],
        ),
      ),
    );
  }
}
