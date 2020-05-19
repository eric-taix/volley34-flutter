import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/cards/titled_card.dart';
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
    _teamBloc = TeamBloc(repository: RepositoryProvider.of<Repository>(context))..add(TeamLoadAverageSlidingResult(code: widget.code, last: 100, count: 3));
  }

  @override
  void dispose() {
    super.dispose();
    _teamBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return TitledCard(
      title: widget.name,
      bodyPadding: EdgeInsets.only(top: 18, bottom: 18, right: 8, left: 16),
      body: BlocBuilder(
        bloc: _teamBloc,
        builder: (context, state) {
          if (state is TeamSlidingStatsLoaded) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                  width: 120, //double.infinity,
                  child: LineGraph(state.results..insert(0, 0), thumbnail: true,),
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
