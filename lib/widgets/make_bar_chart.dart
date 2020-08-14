import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../models/part_volume.dart';

class MakeBarChart extends StatelessWidget {
  final List<PartVolume> graphData;
  MakeBarChart(this.graphData);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PartVolume, String>> _createSampleData() {
      return [
        new charts.Series<PartVolume, String>(
          id: 'Volume',
          domainFn: (PartVolume ptvol, _) =>
              ptvol.part.length > 5 ? ptvol.part.substring(0, 5) : ptvol.part,
          measureFn: (PartVolume ptvol, _) => ptvol.volume,
          colorFn: (PartVolume ptvol, _) => ptvol.color,
          // labelAccessorFn: (PartVolume ptvol, _) => '${ptvol.volume}',
          data: graphData,
        )
      ];
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: charts.BarChart(
        _createSampleData(),
        animate: true,
      ),
    );
  }
}
