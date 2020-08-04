import 'package:flutter/foundation.dart';

class Training with ChangeNotifier {
  String id;
  String part;
  double weights;
  double times;
  double volume;
  String date;

  Training({
    @required this.id,
    @required this.part,
    @required this.weights,
    @required this.times,
    @required this.volume,
    @required this.date,
  });
}
