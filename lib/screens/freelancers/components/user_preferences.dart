import 'package:sirvice_app/models/Freelancer.dart';

class UserPreferences {
  static const gates = Freelancer(
    imagePath:
        'https://upload.wikimedia.org//wikipedia/commons/a/a8/Bill_Gates_2017_%28cropped%29.jpg',
    name: 'Bill Gates',
    email: 'bill.gates@microsoft.com',
    about:
        'Magnata, empresário, diretor executivo, investidor, filantropo e autor americano, conhecido por fundar a Microsoft, a maior e mais conhecida empresa de software do mundo em termos de valor de mercado.',
  );
  static const musk = Freelancer(
    imagePath:
        'https://veja.abril.com.br/wp-content/uploads/2021/04/GettyImages-1229893337.jpg',
    name: 'Elon Musk',
    email: 'elon.musk@tesla.com',
    about:
        'Empreendedor e filantropo sul-africano-canadense-americano. Fundador, CEO e CTO da SpaceX, CEO da Tesla Motors, vice-presidente da OpenAI, fundador e CEO da Neuralink e co-fundador e presidente da SolarCity.',
  );
  static const bezzos = Freelancer(
    imagePath:
        'https://computerworld.com.br/wp-content/uploads/2020/01/Em-meio-a-investiga%C3%A7%C3%B5es-e-protestos-Bezos-anuncia-US-1-bilh%C3%A3o-para-%C3%8Dndia.jpg',
    name: 'Jeff Bezos',
    email: 'jeff.bezzos@amazon.com',
    about:
        'Empresário estadunidense conhecido por fundar, e ter sido o presidente e CEO da Amazon.',
  );
  static const zuck = Freelancer(
    imagePath:
        'https://s2.glbimg.com/FUcw2usZfSTL6yCCGj3L3v3SpJ8=/smart/e.glbimg.com/og/ed/f/original/2019/04/25/zuckerberg_podcast.jpg',
    name: 'Mark Zuckerberg',
    email: 'mark.zuckerberg@facebook.com',
    about:
        'Programador e empresário norte-americano, fundador do Facebook, a rede social mais acessada do mundo.',
  );
}
