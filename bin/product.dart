import 'package:uuid/uuid.dart';

mixin Favourite on BaseProduct {
  void toggleFavouriteStatus(){
    _isFavourite = !_isFavourite;
  }
  bool get isFavourite=>_isFavourite;

}

abstract class BaseProduct implements Comparable<Product> {
  final String _id = const Uuid().v1();
  final String _title;
  final String _description;
  final double _price;
  bool _isFavourite = false;

  BaseProduct(this._title, this._description, this._price);

  @override
  int compareTo(Product other) {
    return (_price - other._price).toInt();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BaseProduct &&
              runtimeType == other.runtimeType &&
              _id == other._id ;

  @override
  int get hashCode => _id.hashCode ;


  @override
  String toString() {
    return "id: $_id"
        "title: $_title"
        "description: $_description"
        "price: $_price";
  }


  String get id => _id;
  String get title => _title;
  String get description => _description;
  double get price => _price;
}

class Product extends BaseProduct with Favourite {
  final String imageUrl;

  Product({
    required String title,
    required String description,
    required double price,
    required this.imageUrl,
  }) : super(title, description, price);



  factory Product.fromJSON(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'] is int ? json['price'].toDouble() : json['price'],
    );
  }

  Product copyWith({ String? anyTitle,
  String? anyDescription,
  double? anyPrice,
  String? anyImageUrl}){
     return Product(title: anyTitle ?? title, description: anyDescription ?? description, price: anyPrice ?? price, imageUrl: anyImageUrl ??imageUrl);
  }

  @override
  String toString() {
    return super.toString() +
          "image URL: $imageUrl"
          "isFavourite: $isFavourite"
    ;
  }


}
