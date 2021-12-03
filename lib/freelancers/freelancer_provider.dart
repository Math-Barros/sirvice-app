import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sirvice_app/freelancers/freelancer_service.dart';

import 'models/freelancer.dart';

class FreelancersProvider with ChangeNotifier {
  late FreelancersService freelancersService = FreelancersService();
  final int _pageSize = 10;

  List<Freelancer> _freelancers = [];
  Map<String, dynamic> _freelancerTitles = {};
  var _isLoading = true;
  var _isError = false;
  var _isSearch = false;
  late StreamSubscription _freelancersSubscription;
  StreamSubscription? _freelancerTitlesSubscription;

  // getters
  List<Freelancer> get freelancers => [..._freelancers];
  Map<String, dynamic> get freelancerTitles => {..._freelancerTitles};
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  bool get isSearch => _isSearch;

  /// Subsbribe to the freelancer stream, Should be called in the [init state] method of the page
  /// from where it is called, stores the result in [freelancer] then calls [fetchFreelancerTitles]
  /// if an error accours the stream will be canceled, and we will set [isError]
  void fetchFreelancers(String locale) {
    // get original first batch of freelancers
    final stream = freelancersService.fetchFreelancers(_pageSize);
    _freelancersSubscription = stream.listen(
      (freelancers) async {
        freelancers.forEach(
            (freelancer) async => await freelancer.translateLanguage(locale));
        _freelancers = freelancers;
        notifyListeners();
        // so that two subscriptions might not be added
        if (_freelancerTitles.isEmpty) {
          fetchFreelancerTitles();
        } else {
          _isLoading = false;
          notifyListeners();
        }
      },
      onError: (error) {
        print('Error fetching freelancers $error');
        _isError = true;
        _isLoading = false;
        notifyListeners();
      },
      cancelOnError: true,
    );
  }

  /// refetch freelancers when an error occurs, reset [loading] and [error]
  /// then call [fetchFreelancers] again to remake the stream
  void reFetchFreelancers(String locale) async {
    _isLoading = true;
    _isError = false;
    _isSearch = false;
    notifyListeners();
    fetchFreelancers(locale);
  }

  /// fetch more freelancers, starts with setting a [silent loader] so that the method does
  /// not get called again. Check if [freelancers] is empty or [isError] or [isSearch] is set
  /// add fetched freelancers at the end of [freelancers], catch errors if any and return
  Future<void> fetchMoreFreelancers(String locale) async {
    // only get called one time and not on error or in a search
    // Aslo if no lastFreelancer to start from, needs to return
    if (_freelancers.isEmpty || _isError || _isSearch) {
      return;
    }
    // get more freelancers
    List<Freelancer> moreFreelancers;
    try {
      moreFreelancers =
          await freelancersService.fetchMoreFreelancers(_pageSize);
    } catch (error) {
      print('Failed to fetch more freelancers: $error');
      return;
    }
    moreFreelancers.forEach(
        (freelancer) async => await freelancer.translateLanguage(locale));
    // add them the end of the messages list
    _freelancers.addAll(moreFreelancers);
    notifyListeners();
  }

  /// Subscbribe to the freelancer titles stream, should only be called from [fetchFreelancers]
  /// store the result in [freelancerTitles] and stop [loading] if an error accours
  /// the stream will be canceled, and we will set [isError]
  void fetchFreelancerTitles() {
    // get freelancer titles
    final stream = freelancersService.fetchFreelancerTitles();
    _freelancerTitlesSubscription = stream.listen(
      (freelancerTitles) {
        _freelancerTitles = freelancerTitles;
        _isError = false;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        print('Error feteching freelancer titles $error');
        _isError = true;
        _isLoading = false;
        notifyListeners();
      },
      cancelOnError: true,
    );
  }

  /// Searches for all freelancers matching a certain title from [firebase] and sets [isSearch] flag
  /// if successfull lists the found freelancers in [freelancers] and cashe prevoius freelancers in [cashedFreelancers]
  /// to be restored when search is cleared, do not store prevoius searches
  /// if an error occurs sets [isError]
  Future<void> fetchSearchedFreelancer(String isbn, String locale) async {
    // get freelancers that fits a cetain title
    _isSearch = true;
    _isLoading = true;
    notifyListeners();
    final _stream = freelancersService.searchFreelancers(isbn);
    await _freelancersSubscription.cancel();
    _freelancersSubscription = _stream.listen(
      (freelancers) {
        freelancers.forEach(
            (freelancer) async => await freelancer.translateLanguage(locale));
        _freelancers = freelancers;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        print('Error fetching searched freelancers $error');
        _isError = true;
        _isLoading = false;
        notifyListeners();
      },
      cancelOnError: true,
    );
  }

  /// Restores the [chashed freelancers], when a search is called
  /// and turns off [isSearch] flag
  void clearSearch(String locale) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _freelancersSubscription.cancel();
      _isSearch = false;
      fetchFreelancers(locale);
    } catch (error) {
      print('Error clearing search $error');
      _isLoading = false;
      _isError = true;
      notifyListeners();
    }
  }

  /// Dispose when the provider is destroyed, cancel the freelancer subscription
  @override
  void dispose() async {
    super.dispose();
    await _freelancersSubscription.cancel();
    await _freelancerTitlesSubscription?.cancel();
  }
}
