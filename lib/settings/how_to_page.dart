import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sirvice_app/localization/localization.dart';

class HowToPage extends StatelessWidget {
  static const routeName = '/howt-to';

  @override
  Widget build(BuildContext context) {
    final loc = Localization.of(context);
    return IntroductionScreen(
      pages: [
        PageViewModel(
            title: loc.getTranslatedValue('how_to_page1_title'),
            body: loc.getTranslatedValue('how_to_page1_body'),
            image: Image.asset(
              'assets/images/add_deal.png',
              height: 240,
            )),
        PageViewModel(
            title: loc.getTranslatedValue('how_to_page2_title'),
            body: loc.getTranslatedValue('how_to_page2_body'),
            image: Image.asset(
              'assets/images/notf.png',
              height: 250,
            )),
        PageViewModel(
            title: loc.getTranslatedValue('how_to_page3_title'),
            body: loc.getTranslatedValue('how_to_page3_body'),
            image: Image.asset(
              'assets/images/message_sent.png',
              height: 250,
            )),
      ],
      showSkipButton: true,
      skip: Text(loc.getTranslatedValue('skip_btn_txt')),
      next: Text(loc.getTranslatedValue('next_btn_txt')),
      done: Text(loc.getTranslatedValue('done_btn_txt')),
      onDone: () async {
        Navigator.of(context).pop();
      },
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).backgroundColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    );
  }
}
