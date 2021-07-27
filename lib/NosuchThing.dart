import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class NosuchThing extends StatelessWidget {
  final String name;
  const NosuchThing({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Icon(
              FontAwesome.exclamation_triangle,
              size: 150,
              color: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                name.toUpperCase() + " is not inside database",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
