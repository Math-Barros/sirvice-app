import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sirvice_app/freelancers/models/freelancer.dart';
import 'package:sirvice_app/localization/localization.dart';

import '../deals_provider.dart';
import 'add_deal_bottom_sheet.dart';
import 'filter_deals_bottom_sheet.dart';

class BlurredImageAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final GlobalKey one;
  final GlobalKey two;

  final Freelancer freelancer;

  BlurredImageAppBar(this.freelancer, this.one, this.two)
      : preferredSize = Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    final loc = Localization.of(context);
    return AppBar(
      brightness: Brightness.dark,
      title: Text(freelancer.titles.first),
      flexibleSpace: ClipRect(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(freelancer.image),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
      ),
      elevation: 0,
      actions: [
        Showcase(
          key: two,
          description: loc.getTranslatedValue('showcase_filter_btn_text'),
          shapeBorder: CircleBorder(),
          contentPadding: EdgeInsets.all(10),
          showArrow: false,
          child: IconButton(
            icon: Icon(Icons.filter_list_rounded),
            onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (_) => ChangeNotifierProvider.value(
                value: context.read<DealsProvider>().provider,
                child: FilterDealsBottomSheet(freelancer),
              ),
            ),
          ),
        ),
        Showcase(
          key: one,
          description: loc.getTranslatedValue('showcase_add_btn_text'),
          shapeBorder: CircleBorder(),
          contentPadding: EdgeInsets.all(10),
          showArrow: false,
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (_) => ChangeNotifierProvider.value(
                value: context.read<DealsProvider>().provider,
                child: AddDealBottomSheet(
                  pid: freelancer.isbn,
                  productImage: freelancer.image,
                  productTitle: freelancer.titles.first,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
