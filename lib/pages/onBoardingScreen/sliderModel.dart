// ignore_for_file: deprecated_member_use

class SliderModel{
  String title;
  String desc;
  String imageAssetPath;

  SliderModel({this.title, this.desc});

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }
}

List<SliderModel> getSlides(){
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  sliderModel.setTitle('Sirvice');
  sliderModel.setDesc('Bem vindo ao Sirvice');
  sliderModel.setImageAssetPath('assets/sIcon.png');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setTitle('Sacola de compras');
  sliderModel.setDesc('Adicionar produtos e checar eles depois' );
  sliderModel.setImageAssetPath('assets/onBoarding/shopping-bag.png');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setTitle('Procurar');
  sliderModel.setDesc('Procure pelo serviço ideal');
  sliderModel.setImageAssetPath('assets/onBoarding/search.png');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setTitle('Fazer pagamento');
  sliderModel.setDesc('Escolhe a opção preferida de pagamento');
  sliderModel.setImageAssetPath('assets/onBoarding/payment.png');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setTitle('Delivery');
  sliderModel.setDesc('Delivery super rápido na porta da sua');
  sliderModel.setImageAssetPath('assets/onBoarding/products-delivery.png');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setTitle('Aproveito suas compras');
  sliderModel.setDesc('Serviços de alta qualidade pelo preço certo');
  sliderModel.setImageAssetPath('assets/onBoarding/premium-quality.png');
  slides.add(sliderModel);

  return slides;
}