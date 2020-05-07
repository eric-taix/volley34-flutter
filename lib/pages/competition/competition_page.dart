import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:v34/commons/no_data.dart';
import 'package:v34/commons/text_tab_bar.dart';

class CompetitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        child: DefaultTabController(
            length: 3,
            child: TextTabBar(tabs: [
              TextTab(
                "Championnat",
                NoData("A venir..."),
              ),
              TextTab(
                "Challenge",
                NoData("A venir..."),
              ),
              TextTab(
                "Coupe",
                NoData("A venir..."),
              ),
            ])));
  }
}
