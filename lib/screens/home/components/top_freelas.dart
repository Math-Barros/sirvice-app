import 'package:flutter/material.dart';
import 'package:sirvice_app/screens/freelancers/profile_page_bezzos.dart';
import 'package:sirvice_app/screens/freelancers/profile_page_gates.dart';
import 'package:sirvice_app/screens/freelancers/profile_page_musk.dart';
import 'package:sirvice_app/screens/freelancers/profile_page_zuck.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class TopFreelas extends StatelessWidget {
  const TopFreelas({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Top Freelancers",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                image: "assets/images/billgates.jpg",
                category: "Bill G.",
                numOfBrands: 18,
                press: () {
                  Navigator.pushNamed(context, ProfilePageGates.routeName);
                },
              ),
              SpecialOfferCard(
                image: "assets/images/elonmusk.jpg",
                category: "Elon M.",
                numOfBrands: 24,
                press: () {
                  Navigator.pushNamed(context, ProfilePageMusk.routeName);
                },
              ),
              SpecialOfferCard(
                image: "assets/images/jeffbezos.jpg",
                category: "Jeff B.",
                numOfBrands: 37,
                press: () {
                  Navigator.pushNamed(context, ProfilePageBezzos.routeName);
                },
              ),
              SpecialOfferCard(
                image: "assets/images/marckzuckerberg.jpg",
                category: "Mark Z.",
                numOfBrands: 12,
                press: () {
                  Navigator.pushNamed(context, ProfilePageZuck.routeName);
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(150),
          height: getProportionateScreenWidth(150),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(12.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(17),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Projetos")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
