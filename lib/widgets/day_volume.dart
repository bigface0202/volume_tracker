import 'package:flutter/material.dart';

import '../models/training_prov.dart';

class DayVolume extends StatefulWidget {
  TrainingProv trainings;
  String trainingDate;
  DayVolume(this.trainings, this.trainingDate);
  @override
  _DayVolumeState createState() => _DayVolumeState();
}

class _DayVolumeState extends State<DayVolume> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // ↓がないとスクロールできない
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.trainings.volumeCalc(widget.trainingDate).length,
      itemBuilder: (ctx, index) {
        String key = widget.trainings
            .volumeCalc(widget.trainingDate)
            .keys
            .elementAt(index);

        return widget.trainings.volumeCalc(widget.trainingDate)[key] > 0
            ? Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(
                  vertical: 5,
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
                        '${widget.trainings.volumeCalc(widget.trainingDate)[key]} vol.',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
