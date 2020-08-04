import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/training_prov.dart';

class TrainingList extends StatefulWidget {
  @override
  _TrainingListState createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingProv>(
      child: Container(
        padding: EdgeInsets.only(top: 265, bottom: 265),
        child: Center(
          child: const Text('Week Done List empty'),
        ),
      ),
      builder: (ctx, trainings, ch) => trainings
                  .volumeCalc(_selectedDate)
                  .length <=
              0
          ? ch
          : ListView.builder(
              // ↓がないとスクロールできない
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: trainings.volumeCalc(_selectedDate).length,
              itemBuilder: (ctx, index) {
                String key =
                    trainings.volumeCalc(_selectedDate).keys.elementAt(index);

                return trainings.volumeCalc(_selectedDate)[key] > 0
                    ? Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            radius: 30,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FittedBox(
                                  child: Text(
                                '$key',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${trainings.volumeCalc(_selectedDate)[key]} vol.',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container();
              },
            ),
    );
  }
}
