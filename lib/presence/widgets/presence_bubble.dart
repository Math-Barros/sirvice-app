import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:sirvice_app/localization/localization.dart';
import 'package:sirvice_app/presence/presence_service.dart';
import 'package:sirvice_app/presence/widgets/timeago_flutter.dart';

/// This widgets as a contrast to others talk directly to a [service] and not through
/// a [provider], this is done since this widget is used in profile, chat list, deal list and
/// chat page and there is no need to send over the same stream through 4 different [providers]
class PresenceBubble extends StatefulWidget {
  static const double smallSize = 20;
  static const double bigSize = 40;
  final String uid;
  final double size;

  PresenceBubble(this.uid, this.size);

  @override
  _PresenceBubbleState createState() => _PresenceBubbleState();
}

class _PresenceBubbleState extends State<PresenceBubble> {
  @override
  Widget build(BuildContext context) {
    /**
         * Stream builder with RTDB works a little bit different then Firestore
         * some documentation is in this medium article
         * https://medium.com/codechai/realtime-database-in-flutter-bef0f29e3378 
         */
    return StreamBuilder(
      stream: PresenceService().getUserPresenceStream(widget.uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          // return shimmer
          return Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.grey[300]!,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: widget.size / 2,
            ),
          );
        }
        var presence = snap.data;

        if (presence == null) {
          return CircleAvatar(
            backgroundColor: Colors.red,
            radius: widget.size / 2.2,
          );
        } else if (presence == true) {
          return CircleAvatar(
            backgroundColor: Colors.green,
            radius: widget.size / 2.2,
          );
        } else {
          return Container(
            height: widget.size,
            decoration: BoxDecoration(
                color: Colors.amber[900],
                borderRadius: BorderRadius.circular(widget.size / (1.125))),
            child: Padding(
              padding: EdgeInsets.all(widget.size / (4.5)),
              child: FittedBox(
                child: Timeago(
                  builder: (_, value) => Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                  date: presence as DateTime,
                  locale: Localization.of(context).getTimeAgoLocale(),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
