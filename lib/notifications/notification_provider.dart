import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sirvice_app/authentication/authentication_service.dart';
import 'package:sirvice_app/following/follow_service.dart';
import 'package:sirvice_app/messages/messages_page.dart';
import 'package:sirvice_app/notifications/notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();

  print('Handling a background message: ${message.messageId}');
}

class NotificationProvider with ChangeNotifier {
  final _authenticationService = AuthenticationService();
  final _notificationsService = NotificationService();
  final _followService = FollowService();

  late StreamSubscription _followingNotificationSubscription;
  late StreamSubscription _chatNotificationSubscription;
  var _followingNotification = false;
  var _chatNotification = false;

  // getters
  bool get followingNotification => _followingNotification;
  bool get chatNotification => _chatNotification;

  /*
   * configure notifications to handle both foreground and background
   * messages, on foreground a flushbar is shown for the user to click and see 
   * notifications. On the data propery a type field is given to check if 
   * notification is a message or freelancer alert. 
   */
  void configureNotifications(
      BuildContext context, Function(int index) setCurrentIndex) async {
    var settings = await _notificationsService.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');

    // handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

      print('Naaaame');
      print(ModalRoute.of(context)!.settings.name);
      if (ModalRoute.of(context)!.settings.name != MessagesPage.routeName) {
        if (message.data['type'] == 'message') {
          final id = message.data['id'];
          final name = message.data['name'];
          final image = message.data['image'];
          final text = message.data['message'];
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                content: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  leading: CircleAvatar(backgroundImage: NetworkImage(image)),
                  title: Text(name),
                  subtitle: Text(text),
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Navigator.pushNamed(
                      context,
                      MessagesPage.routeName,
                      arguments: {'id': id, 'image': image, 'name': name},
                    );
                  },
                )),
          );
        }
        if (message.data['type'] == 'freelancer') {
          //final id = message.data['id'];
          final title = message.data['title'];
          final image = message.data['image'];
          final text = message.data['message'];
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                content: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  leading: Container(
                    height: 90,
                    width: 50,
                    child: Image.network(
                      image,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.wifi_off_rounded,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  title: Text(title),
                  subtitle: Text(text),
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    setCurrentIndex(3);
                  },
                )),
          );
        }
      }
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage?.data['type'] == 'message') {
      await Navigator.pushNamed(
        context,
        MessagesPage.routeName,
        arguments: {
          'id': initialMessage?.data['id'],
          'image': initialMessage?.data['image'],
          'name': initialMessage?.data['name']
        },
      );
    }
    if (initialMessage?.data['type'] == 'freelancer') {
      setCurrentIndex(3);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'message') {
        Navigator.pushNamed(
          context,
          MessagesPage.routeName,
          arguments: {
            'id': message.data['id'],
            'image': message.data['image'],
            'name': message.data['name']
          },
        );
      }
      if (message.data['type'] == 'freelancer') {
        setCurrentIndex(3);
      }
    });

    // setup background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /*
   * get following notification stream, should only get value
   * no error check or cancelation
   */
  void get fetchFollowingNotification {
    // get original following notification indicator
    final user = _authenticationService.currentUser!;
    final stream = _notificationsService.fetchFollowingNotification(user.uid);
    _followingNotificationSubscription = stream.listen(
      (followingNotification) {
        _followingNotification = followingNotification;
        notifyListeners();
      },
    );
  }

  /*
   * get following notification stream, should only get value
   * no error check or cancelation
   */
  void get fetchChatNotification {
    // get original following notification indicator
    final user = _authenticationService.currentUser!;
    final stream = _notificationsService.fetchChatNotification(user.uid);
    _chatNotificationSubscription = stream.listen(
      (chatNotification) {
        _chatNotification = chatNotification;
        notifyListeners();
      },
    );
  }

  Future<void> unsubscribeFromAllTopics() async {
    // unsubscribe from all topics
    final user = _authenticationService.currentUser!;
    final followings = await _followService.getAllFollowingIds(user.uid);
    await _notificationsService.unsubscribeFromTopic(user.uid);
    for (var following in followings) {
      await _notificationsService.unsubscribeFromTopic(following);
    }
  }

  Future<void> subcribeToAllTopics() async {
    // subscribe to all topics
    final user = _authenticationService.currentUser!;
    final followings = await _followService.getAllFollowingIds(user.uid);
    await _notificationsService.subscribeToTopic(user.uid);
    followings.forEach((following) async {
      await _notificationsService.subscribeToTopic(following);
    });
  }

  /*
   * Cancel suscription on dispose 
   */
  @override
  void dispose() async {
    super.dispose();
    await _chatNotificationSubscription.cancel();
    await _followingNotificationSubscription.cancel();
  }
}
