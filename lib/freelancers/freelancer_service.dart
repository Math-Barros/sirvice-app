import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/freelancer.dart';

class FreelancersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentSnapshot _lastFreelancer;

  /// fetch freelancers
  Stream<List<Freelancer>> fetchFreelancers(int pageSize) {
    return _firestore
        .collection('freelancers')
        .orderBy('deals', descending: true)
        .orderBy('followings', descending: true)
        .limit(pageSize)
        .snapshots()
        .map(
      (list) {
        if (list.docs.isNotEmpty) {
          _lastFreelancer = list.docs.last;
        }
        return list.docs
            .map((document) => Freelancer.fromFirestore(document))
            .toList();
      },
    );
  }

  /// fetch and return more freelancers, from current last. If no more freelancers return null
  Future<List<Freelancer>> fetchMoreFreelancers(int pageSize) async {
    final freelancers = await _firestore
        .collection('freelancers')
        .orderBy('deals', descending: true)
        .orderBy('followings', descending: true)
        .startAfterDocument(_lastFreelancer)
        .limit(pageSize)
        .get();
    if (freelancers.docs.isNotEmpty) {
      _lastFreelancer = freelancers.docs.last;
    }
    return freelancers.docs
        .map((document) => Freelancer.fromFirestore(document))
        .toList();
  }

  /// fetch freelancer titles
  Stream<Map<String, dynamic>> fetchFreelancerTitles() {
    return _firestore.collection('freelancers').doc('metadata').snapshots().map(
      (snapshot) {
        Map<String, dynamic> map;
        map = {};
        // check if the document exist
        if (snapshot.exists) {
          // check is the document is not null
          final data = snapshot.data();
          if (data != null) {
            return data['titles'] ?? map;
          }
        }
        return map;
      },
    );
  }

  /// get freelancer
  Future<Freelancer> getFreelancer(String isbn) async {
    final freelancer =
        await _firestore.collection('freelancers').doc(isbn).get();
    return Freelancer.fromFirestore(freelancer);
  }

  /// Search freelancers by title
  Stream<List<Freelancer>> searchFreelancers(String isbn) {
    return _firestore
        .collection('freelancers')
        .where('isbn', isEqualTo: isbn)
        .snapshots()
        .map((freelancers) => freelancers.docs
            .map((document) => Freelancer.fromFirestore(document))
            .toList());
  }
}
