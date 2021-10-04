import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

typedef AddToCartFunc = void Function(
    String productID, {
    required String title,
    required String description,
    required double price,
    });

typedef RemoveFromCartFunc = void Function({required int index});

typedef CostBuilderFunc = double Function(double, int);

mixin builder {
  CostBuilderFunc? defaultCostBuilder =
      (priceVal, quantityVal) => priceVal * quantityVal;
}



abstract class CartItemBase with builder implements Comparable<CartItemBase> {
  final String _id;
  final String _title;
  final String _description;
  final double _price;
  int quantity;

  CartItemBase(
      this._id,
      this._title,
      this._description,
      this._price,
      {this.quantity = 1 }
      );

  String get id => _id;
  String get title => _title;
  String get description => _description;
  double get price => _price;

  double get cost;

  @override
  String toString() {
    return "id: $_id"
        "title: $_title"
        "description: $_description"
        "price: $_price";
  }
}


class CartItem extends CartItemBase {
  final String productID;
  CostBuilderFunc? costBuilder;


  CartItem({
    String? id,
    required this.productID,
    required String title,
    required String  description,
    required double  price,
    CostBuilderFunc? costBuilder,
    }):super(id ?? const Uuid().v1(),title,description,price,quantity:  1){

    this.costBuilder= costBuilder ?? defaultCostBuilder;
  }

  Map<String, dynamic> toJson() => {
    'id':id,
    'productID': productID,
    'title': title,
    'description': description,
    'price': price,
  };


  @override
  String toString() {
    return super.toString() +
          "product ID: $productID" +
          "quantity: $quantity";
  }

  @override
  double get cost => costBuilder!(price,quantity);

  @override
  int compareTo(CartItemBase other) {
   return (_price - other._price).toInt();
  }

}

abstract class CartBase {
  void addToCart(
        {required String productID,
        required String title,
        required String description,
        required double price});
  void removeFromCart({required int index});
  void clearCart();
  int get itemCount;
  int get totalQuantity;
  double get totalPrice;
}


class CartProvider extends CartBase  {

  List<CartItem> _cartItems = [];


  List<Map<String, dynamic>> toJson() {
   final result = _cartItems.map((item) {
     return item.toJson();
   }).toList();

   return result;
  }


//add to Cart
    @override
    void addToCart(
        { required String productID,
          required String title,
          required String description,
          required double price}) {
      final item = _cartItems.firstWhereOrNull((CartItem item) {
        return item.productID == productID;});
      if(item ==null) {
        _cartItems.add(
          CartItem(
            productID: productID,
            title: title,
            description: description,
            price: price,
//              costBuilder: (price,qty)=>price * qty *3
          ),
        );
      }
      else{
        item.quantity = item.quantity + 1;

      }
    }

//remove from Cart
    @override
    void removeFromCart({required int index}) {
      _cartItems.removeAt(index);
    }

    List<CartItem> get items => [..._cartItems];

    @override
    get itemCount => _cartItems.length;


    @override
    int get totalQuantity {
      return _cartItems.isEmpty
          ? 0
          : _cartItems.fold(
          0,
              (int previousItem, CartItem currentItem) =>
          previousItem + currentItem.quantity);
    }

    @override
    double get totalPrice {
      return _cartItems.fold(
          0.0,
              (previousItem, CartItem currentItem) =>
          previousItem + (currentItem.cost));
    }

  @override
  void clearCart() {
    _cartItems.clear();
  }




}