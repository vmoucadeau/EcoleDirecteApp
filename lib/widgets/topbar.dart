import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBar extends StatefulWidget {
  // @override

  final bool isDrawerOpen;
  TopBar({
    bool isDrawerOpen
  }) : this.isDrawerOpen = isDrawerOpen;

  _TopBarState createState() => new _TopBarState(isDrawerOpen);
}

class _TopBarState extends State<TopBar> {
  _TopBarState(this.isDrawerOpen);
  final bool isDrawerOpen;
  @override

  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: 1,
      curve: Curves.fastOutSlowIn,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: isDrawerOpen
                    ? FaIcon(FontAwesomeIcons.times)
                    : FaIcon(FontAwesomeIcons.bars),
                onPressed: () {
                  // TriggerDrawer();
                }),
            Column(
              children: [
                Text("Mon EcoleDirecte",
                    style: GoogleFonts.montserrat(
                        fontSize: 22, fontWeight: FontWeight.w400)),
                Text("Vincent Moucadeau", style: GoogleFonts.montserrat())
              ],
            ),
            CircleAvatar(backgroundColor: Colors.blue)
          ],
        ),
      ),
    );
  }
}
