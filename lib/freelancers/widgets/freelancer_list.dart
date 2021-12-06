import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sirvice_app/deals/deals_page.dart';
import 'package:sirvice_app/freelancers/freelancer_provider.dart';
import 'package:sirvice_app/global/widgets/sirvice_error.dart';
import 'package:sirvice_app/localization/localization.dart';

import 'freelancer_item.dart';

class FreelancerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final freelancers = context.watch<FreelancersProvider>().freelancers;
    final isLoading = context.watch<FreelancersProvider>().isLoading;
    final isError = context.watch<FreelancersProvider>().isError;
    return isError
        ? SliverFillRemaining(
            child: SirviceError(
                context.read<FreelancersProvider>().reFetchFreelancers,
                Localization.of(context).locale.languageCode))
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => isLoading
                  ? Shimmer.fromColors(
                      highlightColor: Theme.of(context).canvasColor,
                      baseColor: Theme.of(context).splashColor,
                      child: FreelancerItem(),
                    )
                  : InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                          DealsPage.routeName,
                          arguments: freelancers[index]),
                      child: FreelancerItem(freelancer: freelancers[index]),
                    ),
              childCount: isLoading ? 6 : freelancers.length,
            ),
          );
  }
}
