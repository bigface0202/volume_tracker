import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volume_tracker/widgets/make_pie_chart.dart';

import '../models/volume_prov.dart';

class TrainingList extends StatefulWidget {
  @override
  _TrainingListState createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  DateTime _selectedDate = DateTime.now();
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
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  volumes.userVolumes[index].date,
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            // buildCard("Shoulder",
                            //     volumes.userVolumes[index].shoulder),
                            // buildCard(
                            //     "Chest", volumes.userVolumes[index].chest),
                            // buildCard(
                            //     "Biceps", volumes.userVolumes[index].biceps),
                            // buildCard(
                            //     "Triceps", volumes.userVolumes[index].triceps),
                            // buildCard("Arm", volumes.userVolumes[index].arm),
                            // buildCard("Back", volumes.userVolumes[index].back),
                            // buildCard("Abdominal",
                            //     volumes.userVolumes[index].abdominal),
                            // buildCard("Leg", volumes.userVolumes[index].leg),
                            SizedBox(
                                width: 500.0,
                                height: 500.0,
                                child:
                                    MakePieChart(volumes.userVolumes[index])),
                          ],
                        ),
                      );
                    },
                  ),
          );
        }
      },
    );
  }

  Card buildCard(String part, double volumes) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Text('$part: $volumes vol.'),
    );
  }
}
