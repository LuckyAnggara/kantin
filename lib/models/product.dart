class Product {
  final String? name, img, desc;
  final double? price;
  final bool? isFavorite;

  Product(
      {required this.name,
      required this.img,
      required this.desc,
      required this.price,
      required this.isFavorite});
}

List<Product> listProduct = [
  Product(
      name: 'Teh Kotak',
      img: 'assets/images/teh_kotak.png',
      desc: 'Teh Kotak Rasa Istimewa',
      price: 5000,
      isFavorite: true),
  Product(
      name: 'Beng Beng',
      img: 'assets/images/bengbeng.png',
      desc: 'Beng Beng Rasa Istimewa',
      price: 2500,
      isFavorite: false),
  Product(
      name: 'Oreo',
      img: 'assets/images/oreo.png',
      desc: 'Oreo Rasa Istimewa',
      price: 2500,
      isFavorite: false),
];
