import 'dart:convert';

import 'package:boac/ClientView.dart';
import 'package:boac/DateView.dart';
import 'package:boac/TradeView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

//https://faun.pub/flutter-implementing-listview-widget-using-json-file-fbd1e3ba60ad
//https://medium.com/flutter-community/flutter-expansion-collapse-view-fde9c51ac438

//https://medium.com/aubergine-solutions/how-to-create-expansion-panel-list-in-flutter-2fba574366e8

//https://stackoverflow.com/questions/50530152/how-to-create-expandable-listview-in-flutter
//  https://flutter-examples.com/creating-expandable-listview-in-flutter/
// https://stackoverflow.com/questions/60905756/how-to-generate-a-dynamic-expansion-tile-list-from-rest-api-in-flutter

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: ClientView(clientID: "zhang",),
      home: Example(),
    );
  }
}






class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static  List<Widget> _widgetOptions = <Widget>[
    DateView(),
    TradeView(),
    ClientView(),
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.redAccent[900],
              hoverColor: Colors.redAccent[900],
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.redAccent[200],
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.calendar_today_sharp,
                  text: 'By Date',
                ),
                GButton(
                  icon: FontAwesome.money,
                  text: 'By Trade ID',
                ),
                GButton(
                  icon: FontAwesome.user,
                  text: 'By Client ID',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}



class name extends StatelessWidget {
  const name({Key key}) : super(key: key);

  Future<String> getapi() async {
    var data = await http
        .get(Uri.parse("http://10.0.2.2:5000/all"));
    var jsondata = jsonDecode(data.body);
    print(jsondata);
    return "hi";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: FutureBuilder<String>(
          future: getapi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}
