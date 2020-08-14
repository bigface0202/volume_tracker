import 'package:charts_flutter/flutter.dart' as charts;

class PartVolume {
  final String part;
  final double volume;
  final charts.Color color;

  PartVolume(
    this.part,
    this.volume,
    this.color,
  );
}
