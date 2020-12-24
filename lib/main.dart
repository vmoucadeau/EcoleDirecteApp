// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'dart:html';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

/*
void main() => runApp(MaterialApp(
      home: HomePage(),
    ));
    */

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(home: HomePage(),)));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Stack(children: [DrawerScreen(), HomeScreen()],)
      body: Stack(children: [LoginPage()]),
    );
  }
}

