import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/training_prov.dart';

class TrainingList extends StatefulWidget {
  @override
  _TrainingListState createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingProv>(
      child: Container(
        padding: EdgeInsets.only(top: 265, bottom: 265),
        child: Center(
          child: const Text('Week Done List empty'),
        ),
      ),
      builder: (ctx, trainings, ch) => trainings.userTrainings.length <= 0
          ? ch
          : ListView.builder(
              // ↓がないとスクロールできない
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: trainings.userTrainings.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: ValueKey(trainings.userTrainings[index].id),
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
                          'Delete ${trainings.userTrainings[index].part}, ${DateFormat.yMMMMEEEEd().format(trainings.userTrainings[index].date)}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    Provider.of<TrainingProv>(context, listen: false)
                        .removeTraining(trainings.userTrainings[index].id);
                  },
                  child: Card(
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
                            ' h',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${trainings.userTrainings[index].times}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text('${trainings.userTrainings[index].part}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      subtitle: Text(
                        DateFormat.yMMMMEEEEd()
                            .format(trainings.userTrainings[index].date),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
