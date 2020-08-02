import 'package:flutter/foundation.dart';

class Training with ChangeNotifier {
  String id;
  String part;
  double weights;
  int times;
  DateTime date;

  Training({
    @required this.id,
    @required this.part,
    @required this.weights,
    @required this.times,
    @required this.date,
  });
}
