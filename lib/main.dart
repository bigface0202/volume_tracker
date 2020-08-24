import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'models/training_prov.dart';
import 'models/volume_prov.dart';
import './screens/tabs_screen.dart';
import './screens/new_training_screen.dart';
import './screens/setting_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
          SettingScreen.routeName: (ctx) => SettingScreen(),
        },
      ),
    );
  }
}
