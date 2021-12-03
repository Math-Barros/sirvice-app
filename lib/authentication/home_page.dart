import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sirvice_app/authentication/authentication_provider.dart';
import 'package:sirvice_app/freelancers/freelancer_provider.dart';
import 'package:sirvice_app/freelancers/freelancers_page.dart';
import 'package:sirvice_app/freelancers/models/freelancer.dart';
import 'package:sirvice_app/localization/localization.dart';
import 'package:sirvice_app/notifications/notification_provider.dart';
import 'package:sirvice_app/notifications/widgets/badge.dart';
import 'package:sirvice_app/presence/presence_provider.dart';

import '../following/follow_page.dart';
import '../following/follow_provider.dart';
import '../global/404_page.dart';
import '../messages/recipients_page.dart';
import '../messages/recipients_provider.dart';
import '../profile/profile_page.dart';
import '../profile/profile_provider.dart';
import '../settings/settings_page.dart';
import '../deals/deals_page.dart';
import '../deals/deals_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _cupertinoTabController = CupertinoTabController();

  // custom routes when possible to navigate to deals page
  Route<dynamic> dealsGeneratedRoutes(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case DealsPage.routeName:
        if (args == null) {
          return MaterialPageRoute(builder: (_) => PageNotFound());
        }
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
              create: (_) => DealsProvider(),
              child: ShowCaseWidget(
                  builder:
                      Builder(builder: (_) => DealsPage(args as Freelancer)))),
        );
      default:
        return MaterialPageRoute(builder: (_) => PageNotFound());
    }
  }

  List<Widget> get _pages => [
        CupertinoTabView(
            builder: (_) => ChangeNotifierProvider(
                create: (_) => FreelancersProvider(), child: FreelancersPage()),
            onGenerateRoute: dealsGeneratedRoutes),
        CupertinoTabView(
            builder: (ctx) => ChangeNotifierProvider(
                  create: (_) => RecipientsProvider(),
                  child: RecipientsPage(),
                )),
        CupertinoTabView(
            builder: (_) {
              final uid = context.read<AuthenticationProvider>().uid;
              return ChangeNotifierProvider(
                  create: (_) => ProfileProvider(), child: ProfilePage(uid));
            },
            onGenerateRoute: dealsGeneratedRoutes),
        CupertinoTabView(
            builder: (ctx) => ChangeNotifierProvider(
                create: (_) => FollowProvider(), child: FollowPage()),
            onGenerateRoute: dealsGeneratedRoutes),
        CupertinoTabView(builder: (ctx) => SettingsPage())
      ];

  @override
  void initState() {
    super.initState();
    // setup notifications
    context
        .read<NotificationProvider>()
        .configureNotifications(context, _setCurrentIndex);

    // fetch notification indicators for bottombar
    context.read<NotificationProvider>().fetchFollowingNotification;
    context.read<NotificationProvider>().fetchChatNotification;

    // subcribe to all topics
    context.read<NotificationProvider>().subcribeToAllTopics();

    // track if paused or resumed etc.. and set up presence
    WidgetsBinding.instance!.addObserver(this);
    context.read<PresenceProvider>().configurePresence();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      context.read<PresenceProvider>().goOffline();
    }

    if (state == AppLifecycleState.resumed) {
      context.read<PresenceProvider>().goOnline();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  void _setCurrentIndex(int index) {
    _cupertinoTabController.index = index;
  }

  @override
  Widget build(BuildContext context) {
    final followingNotification =
        context.watch<NotificationProvider>().followingNotification;
    final chatNotification =
        context.watch<NotificationProvider>().chatNotification;
    final loc = Localization.of(context);
    return CupertinoTabScaffold(
      controller: _cupertinoTabController,
      tabBar: CupertinoTabBar(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.1)),
          backgroundColor: Theme.of(context).canvasColor.withOpacity(1),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.chrome_reader_mode),
                label: loc.getTranslatedValue('freelancers_tab_text')),
            BottomNavigationBarItem(
                icon: chatNotification
                    ? Badge(
                        color: Colors.red[400],
                        child: Icon(Icons.chat_bubble_rounded))
                    : Icon(Icons.chat),
                label: loc.getTranslatedValue('chats_tab_text')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: loc.getTranslatedValue('profile_tab_text')),
            BottomNavigationBarItem(
                icon: followingNotification
                    ? Badge(
                        color: Colors.red[400],
                        child: Icon(Icons.notifications_rounded))
                    : Icon(Icons.notifications_rounded),
                label: loc.getTranslatedValue('follow_tab_text')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: loc.getTranslatedValue('settings_tab_text')),
          ]),
      tabBuilder: (context, index) => _pages[index],
    );
  }
}
