import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sirvice_app/deals/deals_page.dart';
import 'package:sirvice_app/following/follow_provider.dart';
import 'package:sirvice_app/following/widgets/follow_item.dart';
import 'package:sirvice_app/global/widgets/sirvice_error.dart';
import 'package:sirvice_app/localization/localization.dart';

class FollowList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final follows = context.watch<FollowProvider>().follows;
    final isLoading = context.watch<FollowProvider>().isLoading;
    final isError = context.watch<FollowProvider>().isError;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : isError
            ? SirviceError(context.read<FollowProvider>().reFetchFollows)
            : ListView.builder(
                itemBuilder: (_, index) => InkWell(
                  onTap: () async {
                    final freelancer = await context
                        .read<FollowProvider>()
                        .getFollowedFreelancer(follows[index].pid);
                    final locale = Localization.of(context).locale.languageCode;
                    await freelancer.translateLanguage(locale);
                    context
                        .read<FollowProvider>()
                        .removeFollowingNotification(follows[index].pid);
                    // navigate to freelancers page
                    await Navigator.of(context).pushNamed(
                      DealsPage.routeName,
                      arguments: freelancer,
                    );
                  },
                  child: FollowItem(follow: follows[index]),
                ),
                itemCount: follows.length,
              );
  }
}
