import 'dart:collection';

import 'package:boac/DataList.dart';
import 'package:boac/DataPopUp.dart';
import 'package:boac/NosuchThing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class TradeViewDetails extends StatefulWidget {
  final String tradeID;
  TradeViewDetails({Key key, @required this.tradeID}) : super(key: key);

  @override
  _TradeViewDetailsState createState() => _TradeViewDetailsState();
}

class _TradeViewDetailsState extends State<TradeViewDetails> {
  Future<bool> Doesexist() async {
    var data = await http
        .get(Uri.parse("http://127.0.0.1:5000/tradeexist/" + widget.tradeID));
    var datajson = jsonDecode(data.body);
    if (datajson['exist'] == 'true') return true;
    if (datajson['exist'] == 'false') return false;
  }

  Future<LinkedHashMap<String, dynamic>> getclientTrade() async {
    //var data = await http.get(Uri.parse("http://10.0.2.2:5000/getgttStatus/CLIENT-9YL14"));
    var data = await http.get(Uri.parse(
        'http://127.0.0.1:5000/gettradeStatus/' + this.widget.tradeID));
    var datajson = jsonDecode(data.body);
    return datajson;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Doesexist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == false) return NosuchThing(name: "trade");
            return Container(
              child: FutureBuilder(
                future: getclientTrade(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['result'].isEmpty)
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
                                  "This trade is good !!",
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
                    return Column(children: [
                      Text(snapshot.data['result']['FNBEntity']),
                      Text(snapshot.data['result']['clientID']),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: List<String>.from(snapshot.data['result']
                                  ["Incompleted Documents"] as List)
                              .length,
                          itemBuilder: (BuildContext context, int i) {
                            return ListTile(
                              title: Text(List<String>.from(
                                  snapshot.data['result']
                                      ["Incompleted Documents"] as List)[i]),
                            );
                          }),
                    ]);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return CircularProgressIndicator();
                },
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
