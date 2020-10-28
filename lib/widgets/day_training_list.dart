import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/training.dart';
import '../models/training_prov.dart';
import '../models/volume.dart';
import '../models/volume_prov.dart';

class DayTrainingList extends StatefulWidget {
  final String oneday;
  DayTrainingList(this.oneday);

  @override
  _DayTrainingListState createState() => _DayTrainingListState();
}

class _DayTrainingListState extends State<DayTrainingList> {
  void _deleteData(Training deleteDataList) {
    final String deleteId = deleteDataList.id;
    final String updateDate = deleteDataList.date;
    // Delete training in user_trainings table
    Provider.of<TrainingProv>(context, listen: false).removeTraining(deleteId);
    // Update volume in user_volumes table
    if (Provider.of<TrainingProv>(context, listen: false)
            .onedayTrainings(updateDate)
            .length >
        0) {
      final Map calculatedVolume =
          Provider.of<TrainingProv>(context, listen: false)
              .volumeCalc(updateDate);
      final newVol = Volume(
        id: DateTime.now().toString(),
        date: updateDate,
        shoulder: calculatedVolume["Shoulder"],
        chest: calculatedVolume["Chest"],
        biceps: calculatedVolume["Biceps"],
        triceps: calculatedVolume["Triceps"],
        arm: calculatedVolume["Arm"],
        back: calculatedVolume["Back"],
        abdominal: calculatedVolume["Abdominal"],
        leg: calculatedVolume["Leg"],
      );
      Provider.of<VolumeProv>(context, listen: false).addVolume(newVol);
    } else {
      Provider.of<VolumeProv>(context, listen: false).removeVolume(updateDate);
    }
    print("delete");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TrainingProv>(context, listen: false)
          .fetchAndSetTrainings(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Consumer<TrainingProv>(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Center(
                child: const Text('Training list is empty'),
              ),
            ),
            builder: (ctx, trainings, ch) => trainings
                        .onedayTrainings(widget.oneday)
                        .length <=
                    0
                ? ch
                : ListView.builder(
                    // ↓がないとスクロールできない
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: trainings.onedayTrainings(widget.oneday).length,
                    itemBuilder: (ctx, index) {
                      return Dismissible(
                        key: ValueKey(
                            trainings.onedayTrainings(widget.oneday)[index].id),
                        background: Container(
                          color: Theme.of(context).errorColor,
                          child:
                              Icon(Icons.delete, color: Colors.white, size: 40),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Delete ${trainings.onedayTrainings(widget.oneday)[index].part}, ${trainings.onedayTrainings(widget.oneday)[index].weights} kg, ${trainings.onedayTrainings(widget.oneday)[index].times} times',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                          _deleteData(
                              trainings.onedayTrainings(widget.oneday)[index]);
                        },
                        child: buildCard(trainings, index),
                      );
                    },
                  ),
          );
        }
      },
    );
  }

  Card buildCard(TrainingProv trainings, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 5,
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${trainings.onedayTrainings(widget.oneday)[index].part}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              '${trainings.onedayTrainings(widget.oneday)[index].weights} kg',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
            ),
            Text(
              '${trainings.onedayTrainings(widget.oneday)[index].times} times',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              '${trainings.onedayTrainings(widget.oneday)[index].volume.roundToDouble()} vol.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
