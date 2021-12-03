import 'package:flutter/material.dart';
import 'package:sirvice_app/localization/localization.dart';

import '../models/freelancer.dart';

class FreelancerItem extends StatelessWidget {
  final Freelancer? freelancer;

  const FreelancerItem({Key? key, this.freelancer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = Localization.of(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          PhysicalModel(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: (freelancer == null)
                  ? Container(
                      color: Colors.grey,
                      height: 100,
                      width: 70,
                    )
                  : Hero(
                      tag: freelancer!.isbn,
                      child: Image.network(
                        freelancer!.image,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 70,
                        errorBuilder: (_, __, ___) => Container(
                          height: 100,
                          width: 70,
                          child: Icon(
                            Icons.wifi_off_rounded,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (freelancer == null)
                    ? Container(
                        height: 14, color: Colors.grey, width: double.infinity)
                    : Text(freelancer!.titles.first,
                        style: Theme.of(context).textTheme.bodyText1),
                (freelancer == null)
                    ? Container(
                        height: 14, color: Colors.grey, width: double.infinity)
                    : (freelancer!.getAuthors.isNotEmpty)
                        ? Text(freelancer!.getAuthors)
                        : SizedBox(),
                (freelancer == null)
                    ? Container(
                        height: 14, color: Colors.grey, width: double.infinity)
                    : Row(children: [
                        if (freelancer!.year.isNotEmpty)
                          Text(freelancer!.year,
                              style: Theme.of(context).textTheme.caption),
                        SizedBox(
                          width: 5,
                        ),
                        if (freelancer != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                                color: Theme.of(context).splashColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: FittedBox(
                                child: Text(
                                    loc.getTranslatedValue(
                                            'freelancer_deals_count_text') +
                                        ' ${freelancer!.deals}',
                                    style:
                                        Theme.of(context).textTheme.caption)),
                          ),
                        SizedBox(
                          width: 5,
                        ),
                        if (freelancer != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey[100],
                                borderRadius: BorderRadius.circular(10)),
                            child: FittedBox(
                                child: Text(
                                    loc.getTranslatedValue(
                                            'freelancer_follows_count_text') +
                                        ' ${freelancer!.followings}',
                                    style:
                                        Theme.of(context).textTheme.caption)),
                          )
                      ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
