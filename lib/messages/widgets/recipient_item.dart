import 'package:flutter/material.dart';

import 'package:sirvice_app/messages/models/recipient.dart';
import 'package:sirvice_app/presence/widgets/presence_bubble.dart';

class RecipientItem extends StatelessWidget {
  final Recipient recipient;

  const RecipientItem({Key? key, required this.recipient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
                backgroundImage: NetworkImage(recipient.receiverImage)),
          ),
          PresenceBubble(recipient.rid, PresenceBubble.smallSize)
        ],
      ),
      title: Text(
        recipient.receiverName,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        recipient.lastMessage,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: recipient.notification
          ? CircleAvatar(
              radius: 5, backgroundColor: Theme.of(context).backgroundColor)
          : null,
    );
  }
}
