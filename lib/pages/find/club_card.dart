import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/favorite/favorite_icon.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/models/club.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/pages/club-details/club_detail_page.dart';

class ClubCard extends StatefulWidget {
  final Club club;
  final int index;

  ClubCard(this.club, this.index);

  @override
  _ClubCardState createState() => _ClubCardState();
}

class _ClubCardState extends State<ClubCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Card(
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClubDetailPage(widget.club))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0, right: 8.0, bottom: 12.0, left: 48.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          widget.club.shortName,
                          style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(widget.club.name, style: Theme.of(context).textTheme.body1.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Hero(tag: "hero-logo-${widget.club.code}", child: RoundedNetworkImage(40, widget.club.logoUrl)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FavoriteIcon(widget.club.code, FavoriteType.Club, widget.club.favorite),
          ],
        ),
      ],
    );
  }
}
