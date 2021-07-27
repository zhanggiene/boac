import 'package:boac/DateViewDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:intl/intl.dart';

class DateView extends StatefulWidget {
  DateView({Key key}) : super(key: key);

  @override
  _DateViewState createState() => _DateViewState();
}

class _DateViewState extends State<DateView> {
  DateTime _dateTime;

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (_datePicker != null) {
      setState(() {
        _dateTime = _datePicker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("QUERY BY DATE"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                    showCursor: false,
                    readOnly: true,
                    onTap: () {
                      setState(() {
                        _selectDate(context);
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Select Date of trades',
                        hintText: (_dateTime != null)
                            ? (DateFormat('yyyMMdd').format(_dateTime))
                            : "Please select a date",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)))),
              ),
              if (_dateTime == null)
                Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Icon(
                    FontAwesome5.calendar_alt,
                    size: 150,
                    color: Colors.blue,
                  ),
                ),
              if (_dateTime == null)
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "SELECT A DATE!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30),
                  ),
                ),
              if (_dateTime != null)
                Expanded(
                    child: DateViewDetails(
                        time: DateFormat('yyyMMdd').format(_dateTime))),
            ],
          ),
        ));
  }
}

