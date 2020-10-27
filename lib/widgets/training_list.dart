import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volume_tracker/screens/new_training_screen.dart';
import 'package:volume_tracker/widgets/make_pie_chart.dart';

import '../models/volume_prov.dart';
import '../models/volume.dart';
import '../models/training_prov.dart';

class TrainingList extends StatefulWidget {
  @override
  _TrainingListState createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  void _deleteVolume(Volume deleteVolume) {
    Provider.of<VolumeProv>(context, listen: false)
        .removeVolume(deleteVolume.date);
    Provider.of<TrainingProv>(context, listen: false)
        .removeTrainingByDate(deleteVolume.date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<VolumeProv>(context, listen: false).fetchAndSetVolumes(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Consumer<VolumeProv>(
            child: Container(
              padding: EdgeInsets.only(top: 265, bottom: 265),
              child: Center(
                child: const Text('Start new training!'),
              ),
            ),
            builder: (ctx, volumes, ch) => volumes.userVolumes.length <= 0
                ? ch
                : ListView.builder(
                    // ↓がないとスクロールできない
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: volumes.userVolumes.length,
                    itemBuilder: (ctx, index) {
                      return Dismissible(
                        key: ValueKey(volumes.userVolumes[index].id),
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
                        },
                        onDismissed: (direction) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Delete',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                          _deleteVolume(volumes.userVolumes[index]);
                        },
                        child: buildCard(volumes, index),
                      );
                      // return DeleteCard(
                      //   volumes.userVolumes[index].id,
                      //   _deleteVolume(volumes.userVolumes[index].date),
                      //   buildCard(volumes, index),
                      // );
                    },
                  ),
          );
        }
      },
    );
  }

  Card buildCard(VolumeProv volumes, int index) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(NewTrainingScreen.routeName,
              arguments: volumes.userVolumes[index].date);
        },
        child: Container(
          height: 325,
          child: Column(
            children: <Widget>[
              Text(
                volumes.userVolumes[index].date,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 400.0,
                height: 300.0,
                child: MakePieChart(volumes.userVolumes[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
