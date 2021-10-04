mixin Favourite on BaseProduct {
  void toggleFavouriteStatus(){
    _isFavourite = !_isFavourite;
  }
  bool get isFavourite=>_isFavourite;

}

abstract class BaseProduct implements Comparable<Product> {
  final String _id ;
  final String _title;
  final String _description;
  final double _price;
  bool _isFavourite = false;

  BaseProduct(this._id,this._title, this._description, this._price);


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
    required String id,
    required String title,
    required String description,
    required double price,
    required this.imageUrl,
  }) : super(id ,title, description, price);

  Product.empty():imageUrl='',super(DateTime.now().toString(),'','',0);

  factory Product.fromJSON(Map<String, dynamic> json) {
    assert((json['id'] as String).isNotEmpty ,'ID can not be empty!');
    return Product(
      id:json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'] is int ? json['price'].toDouble() : json['price'],
    );
  }


  Product copyWith({
    String? newId,
    String? newTitle,
    String? newDescription,
    double? newPrice,
    String? newImageUrl}){
     return Product(id: newId?? id,
                     title: newTitle ?? title,
                     description: newDescription ?? description,
                     price: newPrice ?? price,
                     imageUrl: newImageUrl ??imageUrl);
  }

 Map<String,dynamic> toJson({bool isFavouriteOn= false}){
   return isFavouriteOn == true ?
   {
      'title':title,
      'description':description,
      'price':price,
      'imageUrl':imageUrl,
      'isFavourite':_isFavourite ,
    }:
   {
     'title':title,
     'description':description,
     'price':price,
     'imageUrl':imageUrl,
   };

  }


  @override
  String toString() {
    return super.toString() +
          "image URL: $imageUrl"
          "isFavourite: $isFavourite"
    ;
  }


}
