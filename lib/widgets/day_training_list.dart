import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/training_prov.dart';

class DayTrainingList extends StatefulWidget {
  final String oneday;
  DayTrainingList(this.oneday);

  @override
  _DayTrainingListState createState() => _DayTrainingListState();
}

class _DayTrainingListState extends State<DayTrainingList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingProv>(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: const Text('Training list empty'),
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
                    child: Icon(Icons.delete, color: Colors.white, size: 40),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text(
                          'Do you want to remove this?',
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(ctx).pop(false); //Comes back
                            },
                          ), //Dont continue
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.of(ctx).pop(true); //Go on
                            },
                          ),
                        ],
                      ),
                    );
                  }, //消す前に確認できる
                  onDismissed: (direction) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Delete ${trainings.onedayTrainings(widget.oneday)[index].part}, ${trainings.onedayTrainings(widget.oneday)[index].weights} kg, ${trainings.onedayTrainings(widget.oneday)[index].times} times',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    Provider.of<TrainingProv>(context, listen: false)
                        .removeTraining(
                            trainings.onedayTrainings(widget.oneday)[index].id);
                  },
                  child: Card(
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
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
                            '${trainings.onedayTrainings(widget.oneday)[index].volume} vol.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
