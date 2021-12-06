import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sirvice_app/global/widgets/paging_view.dart';
import 'package:sirvice_app/presence/widgets/presence_bubble.dart';
import 'package:sirvice_app/profile/profile_page.dart';

import 'messages_provider.dart';
import 'widgets/message_bar.dart';
import 'widgets/messages_list.dart';
import '../global/widgets/sirvice_error.dart';

class MessagesPage extends StatefulWidget {
  static const routeName = '/chat';
  final String rid;
  final String receiverName;
  final String receiverImage;

  const MessagesPage(
      {required this.rid,
      required this.receiverName,
      required this.receiverImage});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    context.read<MessagesProvider>().unsubscribeFromChatNotifications();
    context.read<MessagesProvider>().fetchMessages(widget.rid);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      context.read<MessagesProvider>().subscribeToChatNotifications();
    }

    if (state == AppLifecycleState.resumed) {
      context.read<MessagesProvider>().unsubscribeFromChatNotifications();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<MessagesProvider>().isLoading;
    final isError = context.watch<MessagesProvider>().isError;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        //padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
        backgroundColor:
            CupertinoColors.extraLightBackgroundGray.withOpacity(0.5),
        middle: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(
              ProfilePage.routeName,
              arguments: widget.rid,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.receiverImage),
              ),
              SizedBox(
                width: 10,
              ),
              Text(widget.receiverName),
            ],
          ),
        ),
        trailing: PresenceBubble(widget.rid, PresenceBubble.smallSize),
      ),
      body: isError
          ? Center(
              child: SirviceError(
                  context.read<MessagesProvider>().refetchMessages, widget.rid))
          : isLoading
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: PagingView(
                          action: () => context
                              .read<MessagesProvider>()
                              .fetchMoreMessages(widget.rid),
                          child: MessagesList(),
                        ),
                      ),
                      MessageBar(
                        rid: widget.rid,
                        receiverName: widget.receiverName,
                        receiverImage: widget.receiverImage,
                      ),
                    ],
                  ),
                ),
    );
  }
}
