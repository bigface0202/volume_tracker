import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:volume_tracker/widgets/day_volume.dart';

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
      builder: (ctx, trainings, ch) => trainings.trainingDates.length <= 0
          ? ch
          : ListView.builder(
              // ↓がないとスクロールできない
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: trainings.trainingDates.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        trainings.trainingDates[index],
                        style: TextStyle(fontSize: 20),
                      ),
                      DayVolume(trainings, trainings.trainingDates[index]),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
