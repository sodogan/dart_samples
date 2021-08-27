import 'dart:collection';

import './cart.dart';
import 'package:uuid/uuid.dart';

abstract class OrderItemBase {
  final String _id = const Uuid().v1();
  final DateTime _dateTime;

  OrderItemBase(this._dateTime);

  DateTime get time => _dateTime;


  List<CartItem> get items;
}

class OrderItem extends OrderItemBase {
  final List<CartItem> cartItems;
  final double totalAmount;

  OrderItem({required this.cartItems, required this.totalAmount})
      : super(DateTime.now());

  @override
  List<CartItem> get items =>[...cartItems];

  @override
  String toString(){
    cartItems.forEach(print);
    return 'totalAmount: $totalAmount';
  }
}

abstract class IOrder {
//add to the List
  void addToOrderList({required List<CartItem> items, required double totalAmount});
//remove from the List
  OrderItem removeFromOrderList({required int index});
//clear the order list
  void clearOrderList();

  UnmodifiableListView<OrderItem> get orderList;
}

class OrderListProvider  implements IOrder {
  List<OrderItem> _orderList = [];

//add to the List
  @override
  void addToOrderList({required List<CartItem> items, required double totalAmount}) {
    _orderList.add(
      OrderItem(cartItems: items, totalAmount: totalAmount),
    );
  }

//remove from the List
  @override
  OrderItem removeFromOrderList({required int index}) =>_orderList.removeAt(index);


  @override
  void clearOrderList() =>_orderList.clear();

  @override
  UnmodifiableListView<OrderItem> get orderList => UnmodifiableListView(_orderList);

}
