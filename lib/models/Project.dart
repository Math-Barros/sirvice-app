import 'package:flutter/material.dart';

class Project {
  final int id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  Project({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<Project> demoProducts = [
  Project(
    id: 1,
    images: [
      "assets/images/javaCode.png",
      "assets/images/javaAndroidCode.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title:
        "Aplicação integrada Java e Spring Boot para a criação de um microserviço",
    price: 64.99,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Project(
    id: 2,
    images: [
      "assets/images/kotlinCode.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title:
        "Aplicativo feito em flutter, mini e-commerce com o fluxo de pedido, carrinho de compras e extrato dos pedidos feitos.",
    price: 50.5,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Project(
    id: 3,
    images: [
      "assets/images/gradleMobileCode.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title:
        "Uma ferramenta de automação de compilação, para facilitar a realização dos itens abaixo: \nAdicionar recursos gratuitos e pagos a um aplicativo e configurar sua compilação para compartilhar código entre eles",
    price: 36.55,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Project(
    id: 4,
    images: [
      "assets/images/webdevCode.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title:
        "Desenvolvimento de uma aplicação utilizando o servidor de aplicação tomcat",
    price: 20.20,
    description: description,
    rating: 4.1,
    isFavourite: true,
  ),
];

const String description =
    "Aplicação Spring Boot com suporte para impressão de relatórios em Jasper Reports.";
