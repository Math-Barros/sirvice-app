import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sirvice_app/profile/models/profile.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// set profile data
  Future<void> setProfile({required String uid, required Profile profile}) {
    return _firestore.collection('profiles').doc(uid).set(profile.toMap());
  }

  /// get profile data
  Future<Profile> getProfile(String uid) async {
    final profile = await _firestore.collection('profiles').doc(uid).get();
    return Profile.fromFirestore(profile);
  }

  /// get profile stream
  Stream<Profile> fetchProfile(String uid) {
    return _firestore
        .collection('profiles')
        .doc(uid)
        .snapshots()
        .map((profile) => Profile.fromFirestore(profile));
  }

  /// get the id for the service account
  Future<String> getAdminId() async {
    final admins = await _firestore.collection('admin').get();
    return admins.docs.first.id;
  }
}
