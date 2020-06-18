import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/commons/graphs/arc.dart';
import 'package:v34/commons/graphs/line_graph.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/repositories/repository.dart';

class ClubTeam extends StatefulWidget {
  final String code;
  final String name;

  ClubTeam({this.code, this.name});

  @override
  _ClubTeamState createState() => _ClubTeamState();
}

class _ClubTeamState extends State<ClubTeam> {
  TeamBloc _teamBloc;

  @override
  void initState() {
    super.initState();
    _teamBloc = TeamBloc(repository: RepositoryProvider.of<Repository>(context))
      ..add(TeamLoadAverageSlidingResult(code: widget.code, last: 100, count: 3));
  }

  @override
  void dispose() {
    super.dispose();
    _teamBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final double miniGraphHeight = 60;
    return TitledCard(
      title: widget.name,
      bodyPadding: EdgeInsets.only(top: 18, bottom: 18, right: 8, left: 16),
      body: BlocBuilder(
        bloc: _teamBloc,
        builder: (context, state) {
          if (state is TeamSlidingStatsLoaded) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
                          child: SizedBox(
                            height: miniGraphHeight,
                            child: LineGraph(
                              state.pointsDiffEvolution,
                              thumbnail: true,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
                          child: SizedBox(
                            height: miniGraphHeight,
                            child: ArcGraph(
                              minValue: 0,
                              maxValue: state.pointsPerMax.maximum.toDouble(),
                              value: state.pointsPerMax.value.toDouble(),
                              lineWidth: 6,
                              leftTitle: LeftTitle(
                                show: true,
                                text: "Points",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1,
                              ),
                              valueBuilder: (value, minValue, maxValue) {
                                var percentage = maxValue != 0 ? "${(((value - minValue) / maxValue) * 100).toStringAsFixed(1)}%" : "- -";
                                return Text(percentage);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
                          child: SizedBox(
                            height: miniGraphHeight,
                            child: ArcGraph(
                              minValue: -state.pointsPerMaxWithFactor.maximum.toDouble(),
                              maxValue: state.pointsPerMaxWithFactor.maximum.toDouble(),
                              value: state.pointsPerMaxWithFactor.value.toDouble(),
                              lineWidth: 6,
                              leftTitle: LeftTitle(
                                show: true,
                                text: "Accroche",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1,
                              ),
                              colors: [Colors.blueAccent, Colors.greenAccent],
                              stops: [0.1, 0.95],
                              valueBuilder: (value, minValue, maxValue) {
                                var percentage = maxValue != 0 ? "${((value - minValue) / (maxValue - minValue) * 100).toStringAsFixed(1)}%" : "- -";
                                return Text(percentage);
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
                          child: SizedBox(
                            height: miniGraphHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}