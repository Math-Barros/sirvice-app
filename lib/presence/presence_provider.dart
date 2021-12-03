import 'package:flutter/foundation.dart';

import 'package:sirvice_app/authentication/authentication_service.dart';
import 'package:sirvice_app/presence/presence_service.dart';

class PresenceProvider with ChangeNotifier {
  final _authenticationService = AuthenticationService();
  final _presenceService = PresenceService();

  /*
   * return a user presence stream, the value will be true if the user is online
   * and a timestamp if the user does not have any active connections, this support multiple
   * devices 
   */
  Stream<dynamic> getUserPresenceStream(String uid) {
    return _presenceService.getUserPresenceStream(uid);
  }

  /*
   * Setup user presence should happen on home screen as this screen is reached when
   * the app is restarted and the callbacks needs to be re initialized, which does not
   * happen if happend in login 
   */
  Future<void> configurePresence() async {
    // set the user to be online
    try {
      final user = _authenticationService.currentUser!;
      await _presenceService.configureUserPresence(user.uid);
    } catch (error) {
      print('Error setting presence: $error');
    }
  }

  /*
   * Connect back to the database to get the presence status back
   */
  void goOnline() {
    // set the user to be online
    try {
      _presenceService.connect();
    } catch (error) {
      print('Error setting presence: $error');
    }
  }

  /*
   * remove connection from database, to remove presence status
   * when signing out the subscription should be removed or multiple
   * reconnections are stored
   */
  Future<void> goOffline({bool signout = false}) async {
    // set the user to be online
    try {
      await _presenceService.disconnect(signout: signout);
    } catch (error) {
      print('Error setting presence: $error');
    }
  }

  // remove presence
  Future<void> removePresence() async {
    return _presenceService.disconnect(signout: true);
  }
}
