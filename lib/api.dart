import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

// Session
Future<Session> edlogin(identifiant, password) async {
  final response = await http.post('https://api.ecoledirecte.com/v3/login.awp',
      body: "data=" + jsonEncode(UserIdentifiants(identifiant, password)));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Session.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('EcoleDirecte API Error');
  }
}

class Session {
  final String token;
  final String typecompte;
  final Map<String, dynamic> account;

  Session({this.token, this.typecompte, this.account});

  factory Session.fromJson(Map<String, dynamic> json) {
    // print(json);
    if (json["code"] == 505) {
      print("Identifiant ou mot de passe incorrect");
      return Session(token: "", typecompte: null, account: null);
    } else if (json["code"] == 200) {
      String typecomptejson = json["data"]["accounts"][0]["typeCompte"];

      // print(json["data"]["accounts"][0]);
      if (typecomptejson != "E") {
        print("NOT SUPPORTED");
        return Session(token: "", typecompte: null, account: null);
      }

      return Session(
          token: json["token"],
          typecompte: typecomptejson,
          account: json["data"]["accounts"][0]);
    }

    return Session(token: "", typecompte: null, account: null);
  }
}

class UserIdentifiants {
  final String identifiant, password;
  const UserIdentifiants(this.identifiant, this.password);

  Map<String, dynamic> toJson() =>
      {"identifiant": this.identifiant, "motdepasse": this.password};
}

class UserToken {
  final String token;
  const UserToken(this.token);

  Map<String, dynamic> toJson() => {"token": this.token};
}

// Eleve

class Eleve {
  final Session session;
  final int id;
  final String prenom;
  final String nom;
  final String classe;
  final String picturl;

  Eleve(
      {this.session,
      this.id,
      this.prenom,
      this.nom,
      this.classe,
      this.picturl});

  factory Eleve.fromSession(Session eleve_session) {
    Map<String, dynamic> account = eleve_session.account;
    String photourl =
        "https://" + account["profile"]["photo"].toString().substring(2);
    return Eleve(
        session: eleve_session,
        id: account["id"],
        prenom: account["prenom"],
        nom: account["nom"],
        classe: account["profile"]["classe"]["code"],
        picturl: photourl);
  }

  Future<WorkArray> GetWorkofDay(String date) async {
    final response = await http.post(
        'https://api.ecoledirecte.com/v3/Eleves/' +
            this.id.toString() +
            "/cahierdetexte/" +
            date +
            ".awp?verbe=get&",
        body: "data=" + jsonEncode(UserToken(this.session.token)));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      // print(json["data"]);
      return WorkArray.fromJson(json["data"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('EcoleDirecte API Error');
    }
  }

  Future<List<WorkArray>> FetchCahierDeTexte() async {
    final response = await http.post(
        'https://api.ecoledirecte.com/v3/Eleves/' +
            this.id.toString() +
            "/cahierdetexte.awp?verbe=get&",
        body: "data=" + jsonEncode(UserToken(this.session.token)));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, WorkArray> returnobj = {};
      Map<String, dynamic> json = jsonDecode(response.body);
      Map<String, dynamic> data = json["data"];
      List<WorkArray> worksarraylist = [];
      List<WorkObj> worksobjlist = [];
      data.forEach((k, v) => {
            v.forEach((item) => {worksobjlist.add(WorkObj.fromJson(item))}),
            worksarraylist.add(WorkArray(k, worksobjlist)),
            worksobjlist = []
          });
      return worksarraylist;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('EcoleDirecte API Error');
    }
  }
}

class WorkObj {
  final String matiere;
  final String prof;
  final int id;
  final bool is_eva;

  final String contenu64;
  final String contenu;
  final String donnele;
  final bool is_done;

  const WorkObj(this.id, this.matiere, this.prof, this.is_eva, this.contenu64,
      this.contenu, this.donnele, this.is_done);

  factory WorkObj.fromJson(Map<String, dynamic> matierejson) {
    if (matierejson["aFaire"] == null) {
      return WorkObj(0, "null", "null", false, null, null, null, null);
    }
    if (matierejson["aFaire"] == true) {
      return WorkObj(
          matierejson["idDevoir"],
          matierejson["matiere"],
          null,
          matierejson["interrogation"],
          null,
          null,
          matierejson["donneLe"],
          matierejson["effectue"]);
    } else {
      final Map<String, dynamic> todoobj = matierejson["aFaire"];
      final String contenutext = utf8.decode(base64.decode(todoobj["contenu"]));
      return WorkObj(
          matierejson["id"],
          matierejson["matiere"],
          matierejson["nomProf"],
          matierejson["interrogation"],
          todoobj["contenu"],
          contenutext,
          todoobj["donneLe"],
          todoobj["effectue"]);
    }
  }
}

class WorkArray {
  final String date;
  final List<WorkObj> works;
  const WorkArray(this.date, this.works);

  factory WorkArray.fromJson(Map<String, dynamic> data) {
    final List<WorkObj> worklist = [];
    List<dynamic> matieresarray = data["matieres"];
    WorkObj wobj;
    matieresarray.forEach((item) => {
          wobj = WorkObj.fromJson(item),
          if (wobj.matiere != "null") {worklist.add(WorkObj.fromJson(item))}
        });
    return WorkArray(data["date"], worklist);
  }
}
