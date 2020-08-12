import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../models/volume.dart';
import '../models/part_volume.dart';

class MakePieChart extends StatelessWidget {
  final Volume partsVolume;

  MakePieChart(this.partsVolume);

  /// Create one series with sample hard coded data.
  Widget build(BuildContext context) {
    List<charts.Series<PartVolume, String>> _createSampleData() {
      final data = [
        PartVolume("Shoulder", partsVolume.shoulder),
        new PartVolume("Chest", partsVolume.chest),
        new PartVolume("Biceps", partsVolume.biceps),
        new PartVolume("Triceps", partsVolume.triceps),
        new PartVolume("Arm", partsVolume.arm),
        new PartVolume("Back", partsVolume.back),
        new PartVolume("Abdominal", partsVolume.abdominal),
        new PartVolume("Leg", partsVolume.leg),
      ];

      return [
        new charts.Series<PartVolume, String>(
          id: 'Sales',
          domainFn: (PartVolume ptvol, _) => ptvol.part,
          measureFn: (PartVolume ptvol, _) => ptvol.volume,
          data: data,
        )
      ];
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: charts.PieChart(
        _createSampleData(),
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 100,
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(
              insideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 15),
              outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
