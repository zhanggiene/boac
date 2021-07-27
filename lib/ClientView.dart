import 'package:boac/ClientViewDetails.dart';
import 'package:boac/DateViewDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:intl/intl.dart';

class ClientView extends StatefulWidget {
  ClientView({Key key}) : super(key: key);

  @override
  _DateViewState createState() => _DateViewState();
}

class _DateViewState extends State<ClientView> {
  String clientName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,   
        appBar: AppBar(
          centerTitle: true,
          title: const Text("QUERY BY Client ID"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                     onFieldSubmitted: (String value) {
                    setState(() {
                        clientName = value;
                      });
                      },
                    decoration: InputDecoration(
                        labelText: 'Type in client ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)))),
              ),
              if (clientName == null)
                Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Icon(
                    FontAwesome5.keyboard,
                    size: 150,
                    color: Colors.blue,
                  ),
                ),
              if (clientName == null)
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "TYPE IN CLIENT ID",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30),
                  ),
                ),
              if (clientName != null)
                Expanded(child: ClientViewDetails(clientID: clientName)),
            ],
          ),
        ));
  }
}
