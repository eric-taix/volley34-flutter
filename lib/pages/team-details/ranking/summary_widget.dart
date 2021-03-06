import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/utils/extensions.dart';

class SummaryWidget extends StatelessWidget {
  final String title;
  final ClassificationTeamSynthesis teamStats;

  static final double miniGraphHeight = 100;

  const SummaryWidget({Key key, @required this.title, @required this.teamStats})
      : super(key: key);

  List<BarChartGroupData> showingGroups(
      BuildContext context, ClassificationTeamSynthesis teamStats) {
    return List.generate(7, (i) {
      switch (i) {
        case 0:
          return makeGroupData(context, 0, teamStats.nbSets30.toDouble(),
              Colors.green, teamStats);
        case 1:
          return makeGroupData(context, 1, teamStats.nbSets31.toDouble(),
              Colors.greenAccent, teamStats);
        case 2:
          return makeGroupData(context, 2, teamStats.nbSets32.toDouble(),
              Colors.yellowAccent, teamStats);
        case 3:
          return makeGroupData(context, 3, teamStats.nbSets23.toDouble(),
              Colors.orangeAccent, teamStats);
        case 4:
          return makeGroupData(context, 4, teamStats.nbSets13.toDouble(),
              Colors.deepOrangeAccent, teamStats);
        case 5:
          return makeGroupData(context, 5, teamStats.nbSets03.toDouble(),
              Colors.redAccent, teamStats);
        case 6:
          return makeGroupData(context, 6, teamStats.nbSetsMI.toDouble(),
              Theme.of(context).accentColor, teamStats);
        default:
          return null;
      }
    });
  }

  BarChartGroupData makeGroupData(BuildContext context, int x, double y,
      Color barColor, ClassificationTeamSynthesis teamStats) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: [0],
      barRods: [
        BarChartRodData(
          y: y,
          color: barColor,
          width: 12,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: (teamStats.wonMatches + teamStats.lostMatches).toDouble(),
            color: Theme.of(context).cardTheme.color.tiny(10),
          ),
        ),
      ],
    );
  }

  Widget _buildGraph(BuildContext context) {
    return SizedBox(
      height: miniGraphHeight,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: BarChart(BarChartData(
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.transparent,
              tooltipPadding: const EdgeInsets.only(bottom: 2),
              tooltipBottomMargin: 0,
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return rod.y.toInt() == 0
                    ? null
                    : BarTooltipItem(
                        "${rod.y.toInt()}",
                        TextStyle(
                            color: Theme.of(context).textTheme.bodyText2.color,
                            fontSize: 10,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.bold),
                      );
              },
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              textStyle:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12),
              margin: 2,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return '3-0';
                  case 1:
                    return '3-1';
                  case 2:
                    return '3-2';
                  case 3:
                    return '2-3';
                  case 4:
                    return '1-3';
                  case 5:
                    return '0-3';
                  case 6:
                    return 'NT';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(showTitles: false),
          ),
          barGroups: showingGroups(context, teamStats),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1)),
          Expanded(flex: 2, child: _buildGraph(context)),
        ],
      ),
    );
  }
}
