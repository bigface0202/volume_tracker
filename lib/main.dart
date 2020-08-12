import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/training_prov.dart';
import 'models/volume_prov.dart';
import './screens/tabs_screen.dart';
import './screens/new_training_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => TrainingProv(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => VolumeProv(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        theme: ThemeData(
          primaryColor: Colors.indigo,
        ),
        routes: {
          '/': (ctx) => TabsScreen(),
          NewTrainingScreen.routeName: (ctx) => NewTrainingScreen(),
        },
      ),
    );
  }
}
