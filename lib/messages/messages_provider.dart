import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sirvice_app/authentication/authentication_service.dart';
import 'package:sirvice_app/images/image_cropper_service.dart';
import 'package:sirvice_app/images/image_picker_service.dart';
import 'package:sirvice_app/images/image_upload_service.dart';
import 'package:sirvice_app/location/map_service.dart';
import 'package:sirvice_app/messages/messages_service.dart';
import 'package:sirvice_app/messages/recipients_service.dart';
import 'package:sirvice_app/notifications/notification_service.dart';

import 'models/recipient.dart';
import 'models/message.dart';

class MessagesProvider with ChangeNotifier {
  final _authenticationService = AuthenticationService();
  final _notificationService = NotificationService();
  final _messagesService = MessagesService();
  final _recipientService = RecipientsService();
  final _imageUploadService = ImageUploadService();
  final _imagePickerService = ImagePickerService();
  final _imageCropperService = ImageCropperService();
  final _mapService = MapService();

  final List<Message> _messages = [];
  final seenMap = {'seen': true};
  final _pageSize = 20;
  var _isError = false;
  var _isLoading = true;
  var _messageLoading = false;
  late var _subscription;

  // getters
  MessagesProvider get provider => this;
  List<Message> get messages => [..._messages];
  bool get isLoading => _isLoading;
  bool get messageLoading => _messageLoading;
  bool get isError => _isError;

  /// Subsbribe to the messages stream, Should be called in the [init state] method of the page
  /// from where it is called, reverse the list as it will be shown from bottom opp,
  /// check is messages is already loaded if not store it in [messages], set seen and
  /// remove potensial notification for the receiver and stop [loading]
  /// if an error accours the stream will be canceled, and we will set [isError]
  void fetchMessages(String rid) async {
    // get original first batch of messages, should be called on build
    final user = _authenticationService.currentUser!;
    final stream = _messagesService.fetchMessages(
        sid: user.uid, rid: rid, pageSize: _pageSize);
    _subscription = stream.listen((messages) {
      messages.reversed.toList().forEach((message) {
        message.isMe = message.sid == user.uid;
        // if not already loaded, add to _message list
        if (!_messages.contains(message)) {
          _messages.insert(0, message);
        }

        // change seen status if changed in the databse
        final index = _messages.indexOf(message);
        if (_messages[index].seen != message.seen) {
          _messages[index].seen = message.seen;
        }

        // set message as seen for the sender i.e the other user
        // or set seen for yor self if you are messaging yourself
        if (!message.isMe || rid == user.uid) {
          _messagesService.setSeen(
              id: message.id!, sid: user.uid, rid: rid, message: seenMap);
        }
      });
      // set recipeint notification as false for receiver i.e one self
      const notificationMap = {'notification': false};
      _recipientService.setNotification(
          sid: user.uid, rid: rid, recipient: notificationMap);
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      print('Error fetching messages: $error');
      _isError = true;
      _isLoading = false;
      notifyListeners();
    }, cancelOnError: true);
  }

  /// refetch messages when an error occurs, reset [loading] and [error]
  /// then call [fetchMessages] again to remake the stream
  void refetchMessages(String rid) async {
    _isLoading = true;
    _isError = false;
    notifyListeners();
    fetchMessages(rid);
  }

  /// fetch more messages, starts with setting a [silent loader] so that the method does
  /// not get called again. Check if [messages] is empty or [isError] or [isSearch] is set
  /// add fetched messages at the end of [messages], set seen and catch errors if any and return
  Future<void> fetchMoreMessages(String rid) async {
    // only get called one time and not on error screen
    // Aslo if no lastFollow to start from, needs to return
    if (_messages.isEmpty || _isError) {
      return;
    }

    // get current user and messages
    final user = _authenticationService.currentUser!;
    List<Message> moreMessages;
    try {
      moreMessages = await _messagesService.fetchMoreMessages(
          sid: user.uid, rid: rid, pageSize: _pageSize);
    } catch (error) {
      print('Error fetching more messages $error');
      return;
    }

    // set isMe boolean on all messages
    moreMessages.forEach((message) {
      message.isMe = message.sid == user.uid;
      // set message as seen for the sender i.e the other user
      // Note! is not updated on the fly not a stream, but next time the user enters
      if (!message.isMe) {
        _messagesService.setSeen(
            id: message.id!, sid: user.uid, rid: rid, message: seenMap);
      }
    });
    // add them the end of the messages list
    _messages.addAll(moreMessages);
    notifyListeners();
  }

  /// Send a [message] to another user, store the [message] for the sender and store the
  /// [recipient] information for the sender, [cloud functions] will store the information
  /// for the [receiver]. There should not be a loader, should feel like contant flow.
  /// If successfull return true, if an error occurs return false
  Future<bool> sendMessage({
    required String rid,
    required String receiverName,
    required String receiverImage,
    required String text,
    Message? message,
  }) async {
    final user = _authenticationService.currentUser!;
    final time = Timestamp.now();

    // information about the receiver displayed for the sender
    // chat -- sender --> receiver
    final recipient = Recipient(
      rid: rid,
      time: message?.time ?? time,
      notification: false,
      receiverImage: receiverImage,
      receiverName: receiverName,
      lastMessage: text,
    );

    // my message should not be seen by the recipeint before he load them in
    message ??= message = Message(
      sid: user.uid,
      text: text,
      time: time,
      type: 'text',
      seen: false,
    );

    try {
      await _messagesService.sendMessage(
          sid: user.uid, rid: rid, message: message, recipient: recipient);
    } catch (error) {
      print('Error sending message: $error');
      return false;
    }
    return true;
  }

  /// Send image message to a user, pick a image, cropp it and upload it to [storage]
  /// Then call [sendMessage]. There should not be a loader, should feel like contant flow.
  /// If successfull return true, if an error occurs return false
  Future<bool> sendGif({
    required int height,
    required int width,
    required String url,
    required String rid,
    required String receiverName,
    required String receiverImage,
  }) async {
    _messageLoading = true;
    notifyListeners();
    try {
      // Upload image to firestore chat
      final user = _authenticationService.currentUser!;
      final time = Timestamp.now();
      final message = ImageMessage(
          sid: user.uid,
          text: '',
          image: url,
          height: height,
          width: width,
          time: time,
          type: 'gif',
          seen: false);
      // TODO needs localization
      await sendMessage(
          rid: rid,
          text: 'Du sendte en gif',
          receiverName: receiverName,
          receiverImage: receiverImage,
          message: message);
    } catch (error) {
      print('Error sending message: $error');
      _messageLoading = false;
      notifyListeners();
      return false;
    }
    _messageLoading = false;
    notifyListeners();
    return true;
  }

  /// Send image message to a user, pick a image, cropp it and upload it to [storage]
  /// Then call [sendMessage]. There should not be a loader, should feel like contant flow.
  /// If successfull return true, if an error occurs return false
  Future<bool> sendImage({
    required ImageSource source,
    required String rid,
    required String receiverName,
    required String receiverImage,
  }) async {
    _messageLoading = true;
    notifyListeners();
    try {
      // Choose image from image picker service
      final image = await _imagePickerService.pickImage(source);
      if (image == null) {
        _messageLoading = false;
        notifyListeners();
        // return true since its not an error
        return true;
      }
      // Crop choosen image, need to compress as picker dont compress
      var croppedImage = await _imageCropperService.pickImage(
          image: image, style: CropStyle.rectangle);
      if (croppedImage == null) {
        _messageLoading = false;
        notifyListeners();
        // return true since its not an error
        return true;
      }
      // Upload image to firebase storage
      final imageUrl =
          await _imageUploadService.uploadChatMessageImage(croppedImage);
      var decodedImage =
          await decodeImageFromList(croppedImage.readAsBytesSync());
      // Upload image to firestore chat
      final user = _authenticationService.currentUser!;
      final time = Timestamp.now();
      // TODO need localization
      final message = ImageMessage(
          sid: user.uid,
          text: '',
          image: imageUrl,
          height: decodedImage.height,
          width: decodedImage.width,
          time: time,
          type: 'image',
          seen: false);
      await sendMessage(
          rid: rid,
          text: 'Du sendte et bilde',
          receiverName: receiverName,
          receiverImage: receiverImage,
          message: message);
    } catch (error) {
      print('Error sending message: $error');
      _messageLoading = false;
      notifyListeners();
      return false;
    }
    _messageLoading = false;
    notifyListeners();
    return true;
  }

  /// Send location message to a user, get the address, an image, upload image to [storage]
  /// Then call [sendMessage]. [messageLoading] will shoe a spinner while uploading message.
  /// For [currentLocation] if latitude or longitude is null, we return false as location
  /// would not be reachable. Else if successfull return true, if an error occurs return false
  Future<bool> sendLocation(
      {required bool currentLocation,
      required String rid,
      required String receiverName,
      required String receiverImage,
      double? latitude,
      double? longitude}) async {
    _messageLoading = true;
    notifyListeners();
    try {
      if (latitude == null || longitude == null) {
        print('Error sending location: Lat or Long = null');
        _messageLoading = false;
        notifyListeners();
        return false;
      }
      // Get location address
      final address = await _mapService.getPlaceAddress(
          latitude: latitude, longitude: longitude);
      // Get location image
      final url = _mapService.generateLocationPreviewImage(
          latitude: latitude, longitude: longitude);
      // Upload image to firebase storage
      final image = await _imageUploadService.urlToFile(url);
      final imageUrl = await _imageUploadService.uploadChatMessageImage(image);
      // delete cached file
      await _imageUploadService.deleteLastCachedFile();
      // Upload image to firestore chat
      final user = _authenticationService.currentUser!;
      final time = Timestamp.now();
      final message = LocationMessage(
          sid: user.uid,
          text: '',
          time: time,
          type: 'location',
          seen: false,
          image: imageUrl,
          address: address,
          latitude: latitude,
          longitude: longitude);
      // TODO need localization
      await sendMessage(
          rid: rid,
          text: 'Du sendte en lokasjon',
          receiverName: receiverName,
          receiverImage: receiverImage,
          message: message);
    } catch (error) {
      print('Error sending message: $error');
      _messageLoading = false;
      notifyListeners();
      return false;
    }
    _messageLoading = false;
    notifyListeners();
    return true;
  }

  /// This method is mainly used in the [chat page] to unsubscribe from topics
  /// unsubscribes from the chat topic of the user so that the [notifications] wont apear
  /// dont need to return if action was succesfull ot not
  void unsubscribeFromChatNotifications() async {
    final user = _authenticationService.currentUser!;
    await _notificationService.unsubscribeFromTopic(user.uid);
  }

  /// This method is mainly used in the [chat page] to subscrbibe to a topics
  /// subscribes to the chat topic of the user so that the notifications will apear
  /// dont need to return if action was succesfull or not
  void subscribeToChatNotifications() async {
    final user = _authenticationService.currentUser!;
    await _notificationService.subscribeToTopic(user.uid);
  }

  /// Dispose when the provider is destroyed, cancel the message subscription
  @override
  void dispose() async {
    super.dispose();
    subscribeToChatNotifications();
    await _subscription.cancel();
  }
}
