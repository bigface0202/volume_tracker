import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/make_bar_chart.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  String _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void _startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _dateTimeNotifier.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2021),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      if (pickedDate.isBefore(DateTime.parse(_endDate))) {
        setState(() {
          _dateTimeNotifier.value = pickedDate;
          _startDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        });
      } else {
        setState(() {
          _dateTimeNotifier.value = DateTime.now();
          _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        });
      }
    });
  }

  void _endDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _dateTimeNotifier.value ?? DateTime.now(),
      firstDate: _dateTimeNotifier.value,
      lastDate: DateTime(2021),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        if (pickedDate.isAfter(DateTime.parse(_startDate))) {
          setState(() {
            _endDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        } else {
          setState(() {
            _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Start date: ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '$_startDate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Colors.indigo,
                  onPressed: _startDatePicker,
                ),
                Text('Change date')
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'End date: ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '$_endDate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Colors.indigo,
                  onPressed: _endDatePicker,
                ),
                Text('Change date')
              ],
            )
          ],
        ),
        FlatButton(
          child: Text(
            'Show Graph',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.indigo,
          onPressed: () {},
        ),
        MakeBarChart(),
      ],
    );
  }
}
