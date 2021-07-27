import 'package:boac/DataList.dart';
import 'package:boac/DataPopUp.dart';
import 'package:boac/NosuchThing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ClientViewDetails extends StatefulWidget {
  String clientID;
  ClientViewDetails({Key key,@required this.clientID }) : super(key: key);
  
  @override
  _ClientViewState createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientViewDetails> {


  Future<bool> Doesexist() async {
    var data = await http
        .get(Uri.parse("http://127.0.0.1:5000//clientexist/" + widget.clientID));
    var datajson = jsonDecode(data.body);
    if (datajson['exist'] == 'true')
      return true;
    if (datajson['exist']=='false')
      return false;
  }


  Future<List<DataList>> getclientTrade() async {
    var data = await http.get(Uri.parse("http://127.0.0.1:5000//getgttStatus/"+this.widget.clientID));
    var datajson = jsonDecode(data.body);
    List<DataList> result = [];
    for (var session in datajson['result']) {
      List<DataList> details = [];
      List<DataList> tradesDataListTemp = [];
      List<DataList> documentDataListTemp = [];

      for (var trades in session['trades']) {
        tradesDataListTemp.add((new DataList(trades)));
      }
      for (var doc in session['Incompleted Documents']) {
        documentDataListTemp.add((new DataList(doc)));
      }
      details.add(DataList('trade', tradesDataListTemp));
      details.add(DataList('Incompleted Documents', documentDataListTemp));
      result.add(DataList(session['entityName'], details));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Doesexist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == false)
              return NosuchThing(name: "CLIENT");
            else
              return Container(
                child: FutureBuilder(
                  future: getclientTrade(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0)
                        return Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Column(
                            children: [
                              Icon(
                                FontAwesome.thumbs_up,
                                size: 100,
                                color: Colors.green,
                              ),
                              Center(
                                child: Text(
                                  "All clients are GTT for all trades!!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                        );
                      return 
                          ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int i) {
                                return
                                    DataPopUp((snapshot.data[i]));
                              
                              }
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return SizedBox(
                        height: 40, child: LinearProgressIndicator());
                  },
                ),
              );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
