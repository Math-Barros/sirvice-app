import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:sirvice_app/global/parameters.dart';
import 'package:sirvice_app/messages/widgets/image_message_item.dart';
import 'package:sirvice_app/messages/widgets/location_message_item.dart';

import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = message.time.toDate();
    final formattedDate = DateFormat('EEE d MMM kk:mm').format(date);
    // need row, since the list takes the full width the container with gets over-ruled
    return Row(
      mainAxisAlignment:
          message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.type != 'text' && message.type != 'location')
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(formattedDate,
                        style: Theme.of(context).textTheme.caption),
                    SizedBox(width: 5),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 10,
                      color: message.seen
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).splashColor,
                    )
                  ],
                ),
              ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: message.isMe
                    ? Colors.grey[200]
                    : Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      message.isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight:
                      !message.isMe ? Radius.circular(12) : Radius.circular(0),
                ),
              ),
              constraints: BoxConstraints(maxWidth: MAX_CHAT_IMAGE_WIDTH),
              padding: message.type != 'text'
                  ? EdgeInsets.all(0)
                  : EdgeInsets.all(12),
              margin: EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == 'text' || message.type == 'location')
                    Padding(
                      padding: message.type != 'text'
                          ? EdgeInsets.all(8.0)
                          : EdgeInsets.all(0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(formattedDate,
                              style: Theme.of(context).textTheme.caption),
                          SizedBox(width: 5),
                          Icon(
                            Icons.check_circle_rounded,
                            size: 10,
                            color: message.seen
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).splashColor,
                          )
                        ],
                      ),
                    ),
                  if (message.type == 'text')
                    Text(
                      message.text,
                      style: Theme.of(context).textTheme.subtitle1,
                      //strutStyle: StrutStyle(forceStrutHeight: true),
                    ),
                  if (message.type == 'image')
                    ImageMessageItem(message as ImageMessage),
                  if (message.type == 'gif')
                    ImageMessageItem(message as ImageMessage),
                  if (message.type == 'location')
                    LocationImageItem(message as LocationMessage)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
