import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:sirvice_app/global/utils.dart';
import 'package:sirvice_app/localization/localization.dart';
import 'package:sirvice_app/messages/widgets/message_bottom_sheet.dart';

import '../messages_provider.dart';

class MessageBar extends StatefulWidget {
  final String rid;
  final String receiverName;
  final String receiverImage;

  const MessageBar(
      {required this.rid,
      required this.receiverName,
      required this.receiverImage});

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final _controller = TextEditingController();
  var _showMessageOptions = false;
  var _message = '';

  void _showOptions() {
    HapticFeedback.lightImpact();
    setState(() {
      _showMessageOptions = !_showMessageOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localization.of(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  constraints: BoxConstraints(),
                  icon: Icon(
                    _showMessageOptions ? Icons.cancel_sharp : Icons.add,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () => _showOptions()),
              Expanded(
                child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText:
                            loc.getTranslatedValue('send_message_hint_text'),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.grey[200]!, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.grey[200]!, width: 1)),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        fillColor: Colors.grey[200],
                        filled: true,
                        isDense: true),
                    onChanged: (value) => setState(() => _message = value)),
              ),
              IconButton(
                icon: Icon(Icons.send),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                constraints: BoxConstraints(),
                color: Theme.of(context).primaryColorDark,
                onPressed: _message.trim().isEmpty
                    ? null
                    : () async {
                        // we send message cant be set to empty before it is sent
                        final message = _message;
                        // set state to disable button
                        setState(() {
                          _message = '';
                        });
                        _controller.clear();
                        await onPressHandler(
                            context: context,
                            action: () async => await context
                                .read<MessagesProvider>()
                                .sendMessage(
                                  text: message,
                                  rid: widget.rid,
                                  receiverName: widget.receiverName,
                                  receiverImage: widget.receiverImage,
                                ),
                            errorMessage: loc.getTranslatedValue('error_msg'));
                      },
              ),
            ],
          ),
        ),
        Container(
          height: _showMessageOptions ? null : 0,
          child: MessageBottomSheet(
              hideOptions: _showOptions,
              rid: widget.rid,
              receiverName: widget.receiverName,
              receiverImage: widget.receiverImage),
        ),
      ],
    );
  }
}
