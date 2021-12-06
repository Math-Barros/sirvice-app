import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sirvice_app/freelancers/freelancer_provider.dart';
import 'package:sirvice_app/global/widgets/sirvice_image.dart';
import 'package:sirvice_app/localization/localization.dart';

class FreelancerSearchDelegate extends SearchDelegate<String?> {
  late List<String> freelancerMatches;
  final BuildContext parentContext;
  final Map<String, dynamic> freelancerTitles;

  FreelancerSearchDelegate(this.parentContext, this.freelancerTitles);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return super.appBarTheme(context).copyWith(
        textTheme: theme.textTheme.copyWith(
          headline6: theme.textTheme.bodyText2!
              .copyWith(color: Theme.of(context).hintColor),
        ),
        appBarTheme:
            super.appBarTheme(context).appBarTheme.copyWith(elevation: 1));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        size: 24,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    FocusScope.of(context).unfocus();
    return _buildResultsList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var searchText = '.?';
    for (var i = 0; i < query.length; i++) {
      searchText += query[i] + '.?';
    }

    var regExp = RegExp(
      searchText,
      caseSensitive: false,
      multiLine: false,
    );
    freelancerMatches = freelancerTitles.keys
        .where((k) => regExp.hasMatch(
            freelancerTitles[k]['title'] + freelancerTitles[k]['authors']))
        .toList();

    return _buildResultsList(context);
  }

  Widget _buildResultsList(BuildContext context) {
    if (freelancerMatches.isEmpty) {
      return SirviceImage(
          text: 'Sorry couldn\'t find any matches',
          assetImage: 'assets/images/empty_box.png');
    }
    final locale = Localization.of(context).locale.languageCode;
    return ListView.builder(
      itemCount: freelancerMatches.length,
      itemBuilder: (ctx, index) {
        final title = freelancerTitles[freelancerMatches[index]]['title'] ?? '';
        final image = freelancerTitles[freelancerMatches[index]]['image'] ?? '';
        return ListTile(
          onTap: () {
            parentContext
                .read<FreelancersProvider>()
                .fetchSearchedFreelancer(freelancerMatches[index], locale);
            close(context, null);
          },
          title: Text(title, style: Theme.of(context).textTheme.bodyText2),
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.network(
              image,
              width: 30,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Icon(Icons.wifi_off_rounded, size: 30);
              },
            ),
          ),
        );
      },
    );
  }
}
