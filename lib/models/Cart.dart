import 'Project.dart';

class Cart {
  final Project project;
  final int numOfItem;

  Cart({required this.project, required this.numOfItem});
}

// Demo data for our cart

List<Cart> demoCarts = [
  Cart(project: demoProducts[0], numOfItem: 2),
  Cart(project: demoProducts[1], numOfItem: 1),
  Cart(project: demoProducts[3], numOfItem: 1),
];
