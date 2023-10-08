import 'package:flutter/material.dart';
import 'package:speed_guardian/utils/class.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpeedHistory extends StatefulWidget {
  late List? speedHistory = [];

  SpeedHistory(this.speedHistory, {super.key});

  @override
  SpeedHistoryState createState() => SpeedHistoryState();
}

class SpeedHistoryState extends State<SpeedHistory> {

  List<SpeedInfo> speedData = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      speedData =
      widget.speedHistory!.map((e) {
            return SpeedInfo(
                e["speed"] as int, DateTime.parse(e["timestamp"]));
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Over Speeding History",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
                SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <ChartSeries>[
                      LineSeries<SpeedInfo, DateTime>(
                        dataSource: speedData,
                        xValueMapper: (SpeedInfo speed, _) => speed.timestamp,
                        yValueMapper: (SpeedInfo speed, _) => speed.speed,
                      )
                    ]
                )
            ]
        )
    );
  }
}
