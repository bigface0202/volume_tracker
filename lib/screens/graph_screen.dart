import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../widgets/make_bar_chart.dart';
import '../models/volume_prov.dart';
import '../models/part_volume.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  String _startDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: 6)));
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<PartVolume> periodPartVolume = [];

  @override
  void initState() {
    periodPartVolume =
        _calcPeriod(DateTime.parse(_startDate), DateTime.parse(_endDate));
    super.initState();
  }

  void _startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _dateTimeNotifier.value.subtract(Duration(days: 7)),
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
      initialDate: DateTime.parse(_endDate),
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

  List<PartVolume> _calcPeriod(DateTime sDate, DateTime eDate) {
    Map<String, double> _periodVolume =
        Provider.of<VolumeProv>(context, listen: false)
            .calcPeriodVolume(sDate, eDate);
    final data = [
      PartVolume("Shoulder", _periodVolume['shoulder'],
          charts.MaterialPalette.pink.shadeDefault),
      new PartVolume("Chest", _periodVolume['chest'],
          charts.MaterialPalette.deepOrange.shadeDefault),
      new PartVolume("Biceps", _periodVolume['biceps'],
          charts.MaterialPalette.yellow.shadeDefault),
      new PartVolume("Triceps", _periodVolume['triceps'],
          charts.MaterialPalette.lime.shadeDefault),
      new PartVolume("Arm", _periodVolume['arm'],
          charts.MaterialPalette.green.shadeDefault),
      new PartVolume("Back", _periodVolume['back'],
          charts.MaterialPalette.cyan.shadeDefault),
      new PartVolume("Abdominal", _periodVolume['abdominal'],
          charts.MaterialPalette.indigo.shadeDefault),
      new PartVolume("Leg", _periodVolume['leg'],
          charts.MaterialPalette.purple.shadeDefault),
    ];
    return data;
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
          onPressed: () {
            setState(() {
              periodPartVolume = _calcPeriod(
                  DateTime.parse(_startDate), DateTime.parse(_endDate));
            });
          },
        ),
        periodPartVolume.length > 0
            ? SizedBox(
                width: 400, height: 300, child: MakeBarChart(periodPartVolume))
            : Container(),
      ],
    );
  }
}
