import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sirvice_app/freelancers/freelancer_provider.dart';
import 'package:sirvice_app/localization/localization.dart';
import 'freelancer_search_delegate.dart';

class FreelancerSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // search delegate cant access provider, so freelancers as passed through the constructor
    final freelancerTitles =
        context.watch<FreelancersProvider>().freelancerTitles;
    final isLoading = context.watch<FreelancersProvider>().isLoading;
    final loc = Localization.of(context);
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          primary: Theme.of(context).disabledColor,
          backgroundColor: Theme.of(context).splashColor,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: isLoading
            ? null
            : () => showSearch(
                  context: context,
                  delegate: FreelancerSearchDelegate(context, freelancerTitles),
                ),
        icon: Icon(Icons.search),
        label: Text(loc.getTranslatedValue('freelancer_search_bar_text')),
      ),
    );
  }
}
