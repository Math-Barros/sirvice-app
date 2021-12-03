import 'package:flutter_test/flutter_test.dart';
import 'package:sirvice_app/freelancers/models/freelancer.dart';

void main() {
  test(
      'Should print out list of freelancer authors as a easily readable string',
      () async {
    // GIVEN: freelancer with list of authors: ['Jack Frost', 'Bella Hadi', 'Hassan Ali']
    final freelancer = Freelancer(
        titles: [''],
        edition: '',
        image: '',
        isbn: '',
        language: '',
        pages: '',
        publisher: '',
        year: '',
        deals: 0,
        followings: 0,
        authors: ['Jack Frost', 'Bella Hadi', 'Hassan Ali']);
    // WHEN: freelancer.getAuthors is called
    final authors = freelancer.getAuthors;
    // THEN: authors is 'Jack Frost, Bella Hadi, Hassan Ali'
    expect(authors, 'Jack Frost, Bella Hadi, Hassan Ali');
  });
}
