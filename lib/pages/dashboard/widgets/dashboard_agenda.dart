import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/timeline/timeline.dart';
import 'package:v34/commons/timeline/timeline_items.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/blocs/agenda_bloc.dart';
import 'package:v34/repositories/repository.dart';

class DashboardAgenda extends StatefulWidget {
  final List<Team> teams;

  const DashboardAgenda({Key key, @required this.teams}) : super(key: key);

  @override
  DashboardAgendaState createState() => DashboardAgendaState();
}

class DashboardAgendaState extends State<DashboardAgenda>
    with AutomaticKeepAliveClientMixin {
  // AutomaticKeepAliveClientMixin permits to preserve this state when scrolling on the dashboard

  AgendaBloc _agendaBloc;

  @override
  void initState() {
    super.initState();
    _agendaBloc =
        AgendaBloc(repository: RepositoryProvider.of<Repository>(context));
    _loadTeamsMonthAgenda();
  }

  void _loadTeamsMonthAgenda() {
    _agendaBloc.add(LoadTeamsMonthAgenda(
        teamCodes: widget.teams.map((team) => team.code).toList()));
  }

  @override
  void didUpdateWidget(DashboardAgenda oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!ListEquality().equals(widget.teams, oldWidget.teams)) {
      _loadTeamsMonthAgenda();
    }
  }

  Widget _buildTimeline(AgendaState state) {
    if (state is AgendaLoaded) {
      return Timeline([
        ...groupBy(
                state.events,
                (event) =>
                    DateTime(event.date.year, event.date.month, event.date.day))
            .entries
            .expand((entry) {
          return [
            TimelineItem(date: entry.key, events: [
              ...entry.value.map((e) {
                TimelineItemWidget timelineItemWidget =
                    TimelineItemWidget.from(e);
                return TimelineEvent(
                  child: timelineItemWidget,
                  color: timelineItemWidget.color(),
                );
              })
            ])
          ];
        }),
      ]);
    } else {
      return Container(height: 250, child: Center(child: Loading()));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AgendaBloc, AgendaState>(
      cubit: _agendaBloc,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 28.0),
            child: _buildTimeline(state));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
