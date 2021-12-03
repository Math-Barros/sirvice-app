import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:sirvice_app/global/parameters.dart';
import 'package:sirvice_app/images/photo_page.dart';
import 'package:sirvice_app/messages/models/message.dart';

class ImageMessageItem extends StatelessWidget {
  final ImageMessage message;

  ImageMessageItem(this.message);

  @override
  Widget build(BuildContext context) {
    double? height;
    if (message.height != null && message.width != null) {
      height = message.height!.toDouble() *
          (MAX_CHAT_IMAGE_WIDTH / (message.width!.toDouble()));
    }
    return OpenContainer(
      closedColor: Colors.transparent,
      closedElevation: 0,
      openBuilder: (_, __) => PhotoPage(message.image),
      closedBuilder: (_, __) => Image.network(
        message.image,
        height: height ?? 200,
        gaplessPlayback: true,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height ?? 200,
            color: Theme.of(context).splashColor,
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Center(
          child: Icon(
            Icons.wifi_off_rounded,
            size: 60,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
    );
  }
}
