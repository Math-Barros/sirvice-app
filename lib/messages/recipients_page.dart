import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sirvice_app/global/widgets/paging_view.dart';
import 'package:sirvice_app/localization/localization.dart';
import 'package:sirvice_app/messages/recipients_provider.dart';
import 'package:sirvice_app/messages/widgets/recipients_list.dart';

class RecipientsPage extends StatefulWidget {
  @override
  _RecipientsPageState createState() => _RecipientsPageState();
}

class _RecipientsPageState extends State<RecipientsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecipientsProvider>().fetchRecipients();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<RecipientsProvider>().isLoading;
    final loc = Localization.of(context);
    return Scaffold(
        appBar: CupertinoNavigationBar(
          leading: Icon(
            Icons.forum_rounded,
            size: 50,
            color: Theme.of(context).splashColor,
          ),
          middle: Text(
            loc.getTranslatedValue('recipients_page_topbar_title'),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).hintColor),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : PagingView(
                action: () =>
                    context.read<RecipientsProvider>().fetchMoreRecipients(),
                child: RecipientsList()));
  }
}
