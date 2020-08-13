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
        PartVolume("Shoulder", partsVolume.shoulder,
            charts.MaterialPalette.pink.shadeDefault),
        new PartVolume("Chest", partsVolume.chest,
            charts.MaterialPalette.deepOrange.shadeDefault),
        new PartVolume("Biceps", partsVolume.biceps,
            charts.MaterialPalette.yellow.shadeDefault),
        new PartVolume("Triceps", partsVolume.triceps,
            charts.MaterialPalette.lime.shadeDefault),
        new PartVolume(
            "Arm", partsVolume.arm, charts.MaterialPalette.green.shadeDefault),
        new PartVolume(
            "Back", partsVolume.back, charts.MaterialPalette.cyan.shadeDefault),
        new PartVolume("Abdominal", partsVolume.abdominal,
            charts.MaterialPalette.indigo.shadeDefault),
        new PartVolume(
            "Leg", partsVolume.leg, charts.MaterialPalette.purple.shadeDefault),
      ];

      // Sort
      // data.sort((a, b) => b.volume.compareTo(a.volume));

      return [
        new charts.Series<PartVolume, String>(
          id: 'Volume',
          domainFn: (PartVolume ptvol, _) => ptvol.part,
          measureFn: (PartVolume ptvol, _) => ptvol.volume,
          colorFn: (PartVolume ptvol, _) => ptvol.color,
          labelAccessorFn: (PartVolume ptvol, _) => '${ptvol.volume}',
          data: data,
        )
      ];
    }

    return Container(
      padding: EdgeInsets.all(0),
      child: charts.PieChart(
        _createSampleData(),
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 100,
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(
              insideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 14),
              outsideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 14),
            )
          ],
        ),
        behaviors: [
          new charts.DatumLegend(
            // Positions for "start" and "end" will be left and right respectively
            // for widgets with a build context that has directionality ltr.
            // For rtl, "start" and "end" will be right and left respectively.
            // Since this example has directionality of ltr, the legend is
            // positioned on the right side of the chart.
            position: charts.BehaviorPosition.end,
            // For a legend that is positioned on the left or right of the chart,
            // setting the justification for [endDrawArea] is aligned to the
            // bottom of the chart draw area.
            outsideJustification: charts.OutsideJustification.endDrawArea,
            // By default, if the position of the chart is on the left or right of
            // the chart, [horizontalFirst] is set to false. This means that the
            // legend entries will grow as new rows first instead of a new column.
            horizontalFirst: false,
            // By setting this value to 2, the legend entries will grow up to two
            // rows before adding a new column.
            desiredMaxRows: 8,
            // This defines the padding around each legend entry.
            cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
            // Render the legend entry text with custom styles.
            entryTextStyle: charts.TextStyleSpec(
                color: charts.MaterialPalette.purple.shadeDefault,
                fontFamily: 'Georgia',
                fontSize: 15),
          )
        ],
      ),
    );
  }
}
