import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sirvice_app/global/widgets/paging_view.dart';
import 'package:sirvice_app/localization/localization.dart';

import 'widgets/freelancer_list.dart';
import 'widgets/freelancer_search_bar.dart';
import 'freelancer_provider.dart';

class FreelancersPage extends StatefulWidget {
  @override
  _FreelancersPageState createState() => _FreelancersPageState();
}

class _FreelancersPageState extends State<FreelancersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context
        .read<FreelancersProvider>()
        .fetchFreelancers(Localization.of(context).locale.languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final isSearch = context.watch<FreelancersProvider>().isSearch;
    final loc = Localization.of(context);
    return Scaffold(
      body: PagingView(
        action: () => context
            .read<FreelancersProvider>()
            .fetchMoreFreelancers(loc.locale.languageCode),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).canvasColor,
                  elevation: 1,
                  title: FreelancerSearchBar(),
                  floating: true,
                ),
                FreelancerList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isSearch
          ? FloatingActionButton.extended(
              onPressed: () => context
                  .read<FreelancersProvider>()
                  .clearSearch(Localization.of(context).locale.languageCode),
              label: Text(loc.getTranslatedValue('clear_search_btn_text')),
              icon: Icon(Icons.search_off_rounded),
            )
          : null,
    );
  }
}
