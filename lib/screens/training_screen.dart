import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/training_list.dart';
import '../models/volume_prov.dart';

class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
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
          await Navigator.of(context).pushNamed('/new-training');
        },
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
