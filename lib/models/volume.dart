import 'package:flutter/foundation.dart';

class Volume with ChangeNotifier {
  String id;
  String date;
  double shoulder;
  double chest;
  double biceps;
  double triceps;
  double arm;
  double back;
  double abdominal;
  double leg;

  Volume({
    @required this.id,
    @required this.date,
    @required this.shoulder,
    @required this.chest,
    @required this.biceps,
    @required this.triceps,
    @required this.arm,
    @required this.back,
    @required this.abdominal,
    @required this.leg,
  });
}
