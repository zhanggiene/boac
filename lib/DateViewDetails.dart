import 'package:boac/DataList.dart';
import 'package:boac/DataPopUp.dart';
import 'package:boac/NosuchThing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';

class DateViewDetails extends StatefulWidget {
  String time;
  DateViewDetails({Key key, @required this.time}) : super(key: key);

  @override
  _DateViewDetailsState createState() => _DateViewDetailsState();
}

class _DateViewDetailsState extends State<DateViewDetails> {
  Future<bool> Doesexist() async {
    print(widget.time);
    var data = await http
        .get(Uri.parse("http://127.0.0.1:5000/dateexist/" + widget.time));
    var datajson = jsonDecode(data.body);
    if (datajson['exist'] == 'true')
      return true;
    if (datajson['exist']=='false')
      return false;
  }

  Future<List<DataList>> getDateDetails() async {
    //var data = await http.get(Uri.parse("http://10.0.2.2:5000/getgttStatus/CLIENT-9YL14"));
    var data = await http
        .get(Uri.parse("http://127.0.0.1:5000/getdateStatus/" + widget.time));
    var datajson = jsonDecode(data.body);
    List<DataList> result = [];
    for (var session in datajson['result']) {
      List<DataList> details = [];
      List<DataList> tradesDataListTemp = [];
      List<DataList> documentDataListTemp = [];

      for (var doc in session['Incompleted Documents']) {
        List<DataList> documents = [];
        for (var doci in doc['documents']) {
          documents.add(new DataList(doci));
        }
        documentDataListTemp.add((new DataList(doc['entityName'], documents)));
      }

      for (var trades in session['tradeID']) {
        tradesDataListTemp.add((new DataList(trades)));
      }
      details.add(DataList('tradeID', tradesDataListTemp));
      details.add(DataList('Incompleted Docuemnts', documentDataListTemp));
      result.add(DataList(session['clientName'], details));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Doesexist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data== false)
              return NosuchThing(name: "date");
            else
              return Container(
                child: FutureBuilder(
                  future: getDateDetails(),
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
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int i) {
                            return DataPopUp((snapshot.data[i]));
                          });
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
