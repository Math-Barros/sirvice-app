import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sirvice_app/following/follow_provider.dart';
import 'package:sirvice_app/following/widgets/follow_list.dart';
import 'package:sirvice_app/global/widgets/paging_view.dart';
import 'package:sirvice_app/localization/localization.dart';

class FollowPage extends StatefulWidget {
  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  @override
  void initState() {
    super.initState();
    context.read<FollowProvider>().fetchFollows();
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localization.of(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: Icon(Icons.notifications_on_rounded,
            size: 45, color: Theme.of(context).splashColor),
        middle: Text(loc.getTranslatedValue('follow_page_topbar_title'),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).hintColor)),
      ),
      body: PagingView(
          action: () => context.read<FollowProvider>().fetchMoreFollows(),
          child: FollowList()),
    );
  }
}
