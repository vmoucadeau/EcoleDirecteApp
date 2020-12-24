import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;




// Session
Future<Session> edlogin(identifiant, password) async {
  final response =
      await http.post('https://api.ecoledirecte.com/v3/login.awp', body: "data=" + jsonEncode(UserIdentifiants(identifiant, password)));

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
    if(json["code"] == 505) {
      print("Identifiant ou mot de passe incorrect");
      return Session(token: "", typecompte: null, account: null);
    }
    else if(json["code"] == 200) {
      String typecomptejson = json["data"]["accounts"][0]["typeCompte"];
      print(typecomptejson);
      // print(json["data"]["accounts"][0]);
      if(typecomptejson != "E") {
        print("NOT SUPPORTED");
        return Session(token: "", typecompte: null, account: null);
      }

      return Session(
        token: json["token"],
        typecompte: typecomptejson,
        account: json["data"]["accounts"][0]
      );
    }

    return Session(token: "", typecompte: null, account: null);
    
  }

}



class UserIdentifiants {
  final String identifiant, password;
  const UserIdentifiants(this.identifiant, this.password);
 
  Map<String, dynamic> toJson() => {
    "identifiant": this.identifiant,
    "motdepasse": this.password
  };
}


// Eleve

class Eleve {
  final Session session;
  final int id;
  final String prenom;
  final String nom;
  final String classe;
  final String picturl;
  

  Eleve({this.session, this.id, this.prenom, this.nom, this.classe, this.picturl});

  factory Eleve.fromSession(Session eleve) {
    Map<String, dynamic> account = eleve.account;
    String photourl = "https://" + account["profile"]["photo"].toString().substring(2);
    print(photourl);
    return Eleve(session: eleve, id: account["id"], prenom: account["prenom"], nom: account["nom"], classe: account["profile"]["classe"]["code"], picturl: photourl);
  }

}