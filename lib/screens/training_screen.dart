import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../widgets/training_list.dart';
import '../models/volume_prov.dart';
import '../screens/new_training_screen.dart';

class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  List<TargetFocus> targets = List();
  GlobalKey lockTutorialKey = GlobalKey();
  TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    // TODO: implement initState
    targets.add(
      TargetFocus(
        identify: 'test1',
        keyTarget: lockTutorialKey,
        contents: [
          ContentTarget(
            align: AlignContent.bottom,
            child: Text('AAA'),
          )
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
    super.initState();
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8, onFinish: () {
      print("finish");
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print("skip");
    })
      ..show();
  }

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
        key: lockTutorialKey,
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
