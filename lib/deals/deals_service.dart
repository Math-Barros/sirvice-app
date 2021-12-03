import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/deal.dart';
import 'models/deal_filter.dart';

/// Deals service fetches deals for a certain freelancer, the page fetching can be accessed
/// from multiple tabs in the app therefore, does each tab page have their own
/// [Dealservice] object in their respective [provider], to not overlap same data.
class DealsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentSnapshot _lastDeal;
  late DocumentSnapshot _lastFilteredDeal;

  /// fetch deals
  Stream<List<Deal>> fetchDeals({required String isbn, required int pageSize}) {
    return _firestore
        .collection('freelancers/' + isbn + '/deals')
        .orderBy('price')
        .limit(pageSize)
        .snapshots()
        .map(
      (list) {
        if (list.docs.isNotEmpty) {
          _lastDeal = list.docs.last;
        }
        return list.docs
            .map((document) => Deal.fromFirestore(document))
            .toList();
      },
    );
  }

  /// fetch and return more deals, from current last. If no more deals return null
  Future<List<Deal>> fetchMoreDeals(
      {required String isbn, required int pageSize}) async {
    final deals = await _firestore
        .collection('freelancers/' + isbn + '/deals')
        .orderBy('price')
        .startAfterDocument(_lastDeal)
        .limit(pageSize)
        .get();
    if (deals.docs.isNotEmpty) {
      _lastDeal = deals.docs.last;
    }
    return deals.docs.map((document) => Deal.fromFirestore(document)).toList();
  }

  /// filter deals for a spesific freelancer
  Stream<List<Deal>> filterDeals({
    required String isbn,
    required int priceAbove,
    required int priceBelow,
    required List<String> places,
    required String quality,
    required int pageSize,
  }) {
    var query = _firestore
        .collection('freelancers/' + isbn + '/deals')
        .orderBy('price')
        .where('price', isGreaterThanOrEqualTo: priceAbove)
        .where('price', isLessThanOrEqualTo: priceBelow)
        .limit(pageSize);
    if (quality.isNotEmpty) {
      query = query.where('quality', isEqualTo: quality);
    }
    if (places.isNotEmpty) {
      query = query.where('place', whereIn: places);
    }
    // get the deals matching the query
    return query.snapshots().map((list) {
      if (list.docs.isNotEmpty) {
        _lastFilteredDeal = list.docs.last;
      }
      // map the deals to the Deal model
      return list.docs.map((doc) => Deal.fromFirestore(doc)).toList();
    });
  }

  /// fetch and return more filtered deals, from current last. If no more deals return null
  Future<List<Deal>> fetchMoreFilteredDeals({
    required String isbn,
    required int pageSize,
    required DealFilter dealFilter,
  }) async {
    var query = _firestore
        .collection('freelancers/' + isbn + '/deals')
        .orderBy('price')
        .startAfterDocument(_lastFilteredDeal)
        .where('price', isGreaterThanOrEqualTo: dealFilter.priceAbove)
        .where('price', isLessThanOrEqualTo: dealFilter.priceBelow)
        .limit(pageSize);
    if (dealFilter.quality!.isNotEmpty) {
      query = query.where('quality', isEqualTo: dealFilter.quality);
    }
    if (dealFilter.places!.isNotEmpty) {
      query = query.where('place', whereIn: dealFilter.places);
    }
    // get the deals matching the query
    final deals = await query.get();
    // map the deals to the Deal model
    if (deals.docs.isNotEmpty) {
      _lastFilteredDeal = deals.docs.last;
    }
    return deals.docs.map((document) => Deal.fromFirestore(document)).toList();
  }

  /// get a new deal id
  String getDealId(String productId) {
    return _firestore
        .collection('freelancers')
        .doc(productId)
        .collection('deals')
        .doc()
        .id;
  }

  /// add deal to a spesific freelancer
  Future<void> setDeal({required Deal deal, required String id}) {
    return _firestore
        .collection('freelancers')
        .doc(deal.pid)
        .collection('deals')
        .doc(id)
        .set(deal.toMap(), SetOptions(merge: true));
  }

  /// delete a deal
  Future<void> deleteDeal({required String pid, required String id}) {
    return _firestore
        .collection('freelancers')
        .doc(pid)
        .collection('deals')
        .doc(id)
        .delete();
  }
}
