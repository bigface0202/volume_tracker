import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/training_list.dart';
import '../models/volume_prov.dart';
import '../screens/new_training_screen.dart';

class TrainingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FutureBuilder(
              future: Provider.of<VolumeProv>(context, listen: false)
                  .fetchAndSetVolumes(),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : TrainingList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).pushNamed(NewTrainingScreen.routeName,
              arguments: DateFormat('yyyy-MM-dd').format(DateTime.now()));
        },
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
