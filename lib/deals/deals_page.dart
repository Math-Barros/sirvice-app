import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sirvice_app/deals/widgets/deal_list.dart';
import 'package:sirvice_app/freelancers/models/freelancer.dart';
import 'package:sirvice_app/global/utils.dart';
import 'package:sirvice_app/global/widgets/sirvice_error.dart';
import 'package:sirvice_app/global/widgets/paging_view.dart';
import 'package:sirvice_app/localization/localization.dart';

import '../deals/deals_provider.dart';
import 'widgets/blurred_image_app_bar.dart';
import 'widgets/freelancer_info.dart';

class DealsPage extends StatefulWidget {
  static const routeName = '/deals';
  static const SHOWCASE = 'DEALS_PAGE_SHOWCASE';
  final Freelancer freelancer;

  DealsPage(this.freelancer);

  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<DealsProvider>().fetchDeals(widget.freelancer.isbn);

    WidgetsBinding.instance.addPostFrameCallback((_) => _isFirstLaunch().then((result) {
              if (result) {
                ShowCaseWidget.of(context)!.startShowCase([_one, _two, _three]);
              }
            }));
  }

  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final isFirstLaunch = sharedPreferences.getBool(DealsPage.SHOWCASE) ?? true;

    if (isFirstLaunch) {
      await sharedPreferences.setBool(DealsPage.SHOWCASE, false);
    }
    return isFirstLaunch;
  }

  @override
Widget build(BuildContext context) {
  final isFilter = context.watch<DealsProvider>().isFilter;
  final isLoading = context.watch<DealsProvider>().isLoading;
  final isError = context.watch<DealsProvider>().isError;
  final isFollowBtnLoading = context.watch<DealsProvider>().isFollowBtnLoading;
  final isFollowing = context.watch<DealsProvider>().isFollowing;
  final loc = Localization.of(context);
  return Scaffold(
    appBar: BlurredImageAppBar(widget.freelancer, _one, _two),
    body: PagingView(
      action: () => context
          .read<DealsProvider>()
          .fetchMoreDeals(widget.freelancer.isbn),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FreelancerInfo(widget.freelancer),
            ),
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Showcase(
    key: _three,
    description: loc.getTranslatedValue('showcase_follow_btn_text'),
    showArrow: false,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.all(10), // Adicione o padding aqui
        shape: RoundedRectangleBorder(), // Adicione o shape aqui
      ),
      onPressed: (isLoading || isFollowing)
        ? null
        : () => onPressHandler(
            context: context,
            action: () async => await context
              .read<DealsProvider>()
              .followFreelancer(widget.freelancer),
            successMessage: loc.getTranslatedValue('follow_success_msg_text'),
            errorMessage: loc.getTranslatedValue('error_msg'),
          ),
      child: isFollowBtnLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          )
        : Text(loc.getTranslatedValue('follow_btn_text')),
    ),
  ),
),


            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 60),
              child: isLoading
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : isError
                      ? SirviceError(
                          context.read<DealsProvider>().refetchDeals,
                          widget.freelancer.isbn)
                      : DealList(),
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: isFilter
        ? FloatingActionButton.extended(
            onPressed: () => context
                .read<DealsProvider>()
                .clearFilter(widget.freelancer.isbn),
            label: Text(loc.getTranslatedValue('clear_filter_btn_text')),
            icon: Icon(Icons.clear_all_rounded),
          )
        : null,
  );
}


}
