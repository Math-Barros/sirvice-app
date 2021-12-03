import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sirvice_app/freelancers/models/freelancer.dart';
import 'package:sirvice_app/images/photo_page.dart';
import 'package:sirvice_app/localization/localization.dart';

class FreelancerInfo extends StatelessWidget {
  final Freelancer freelancer;

  FreelancerInfo(this.freelancer);

  @override
  Widget build(BuildContext context) {
    final loc = Localization.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          OpenContainer(
            useRootNavigator: true,
            openBuilder: (_, __) => PhotoPage(freelancer.image),
            closedBuilder: (_, __) => Container(
              height: 200,
              width: 150,
              child: Hero(
                  tag: freelancer.isbn,
                  child: Image.network(
                    freelancer.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.wifi_off_rounded,
                      size: 60,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  )),
            ),
          ),
          Flexible(
            child: Column(
              children: [
                if (freelancer.language.isNotEmpty)
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.language),
                    title: freelancer.translatedLanguage.isNotEmpty
                        ? Text(freelancer.translatedLanguage)
                        : Text(freelancer.language),
                  ),
                if (freelancer.pages.isNotEmpty)
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.description),
                    title: Text(freelancer.pages +
                        loc.getTranslatedValue('deal_item_page_count_suffix')),
                  ),
                if (freelancer.edition.isNotEmpty)
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.edit_rounded),
                    title: Text(freelancer.edition),
                  ),
                if (freelancer.publisher.isNotEmpty)
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.menu_book_rounded),
                    title: Text(freelancer.publisher),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
