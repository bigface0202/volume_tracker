import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:volume_tracker/models/volume_prov.dart';

import '../models/volume.dart';
import '../models/volume_prov.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    // final volume = Provider.of<VolumeProv>(context);
    // List<charts.Series<Volume, double>> _createSampleData() {
    //   return [
    //     new charts.Series<Volume, double>(
    //       id: 'Key',
    //       domainFn: (Volume keyandtime, _) => keyandtime.key,
    //       measureFn: (Volume keyandtime, _) => keyandtime.sumTime,
    //       data: volume.userVolumes,
    //     )
    //   ];
    // }

    // return transaction.sumSpendTime.length == 0
    //     ? Container()
    //     : Container(
    //         // child: Text(transaction.sumSpendTime()[0].key),
    //         padding: EdgeInsets.all(60),
    //         child: charts.PieChart(
    //           _createSampleData(),
    //           animate: true,
    //           defaultRenderer: new charts.ArcRendererConfig(
    //             arcWidth: 100,
    //             arcRendererDecorators: [
    //               new charts.ArcLabelDecorator(
    //                 insideLabelStyleSpec:
    //                     new charts.TextStyleSpec(fontSize: 15),
    //                 outsideLabelStyleSpec:
    //                     new charts.TextStyleSpec(fontSize: 15),
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    return Container();
  }
}
