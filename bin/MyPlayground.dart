import './models/dummy_data.dart';
import './category.dart';
import './meal.dart';
import './product.dart';
import './user.dart';
import './core_state.dart';
import './color.dart';
import 'cart.dart';
import 'package:collection/collection.dart';
import 'order.dart';
import 'package:intl/intl.dart';

List<Map<String,Product>> transform(){
  List<Map<String,Product>> result = [];
  final List<Product> productList = DUMMY_PRODUCTS;

  return productList.map((Product product) {
    return {
      "$product.id":product
    };
//    result.add(item);
  }).toList();

//  return result;
}



void main() {
  final product1 = Product(
      title: 'red shirt', price: 7, description: 'a shirt', imageUrl: 'local');

   final copy = product1.copyWith(anyTitle: 'overriden');

  final product2 = Product(title: 'green shirt',
      price: 11,
      description: 'a shirt',
      imageUrl: 'local');
  final product3 = Product(title: 'black shirt',
      price: 3.78,
      description: 'a shirt',
      imageUrl: 'local');


  final cart = CartProvider();

  cart.addToCart(
      '1', title: 'Tshirt', description: 'Blue tshirt', price: 29.99);
  cart.addToCart(
      '1', title: 'Tshirt', description: 'Blue tshirt', price: 29.99);
  cart.addToCart(
      '2', title: 'Tshirt', description: 'Blue tshirt', price: 19.99);


  print('***end');
  //print('Cart: ${cart.items}');
  //print('total number: ${cart.totalQuantity}  Total Price: ${cart.totalPrice}');

  final orderLisProvider= OrderListProvider();
  orderLisProvider.addToOrderList(items: cart.items,totalAmount: cart.totalPrice);

  print(orderLisProvider.orderList);


  /*
  final dummyProducts = DUMMY_PRODUCTS;
  print(dummyProducts);
  final totalPrice =  dummyProducts.fold(0.0, ( double previousValue, Product product) => previousValue + product.price );

  try {
    final item = dummyProducts.firstWhere((item) {
      return item.title.startsWith('Sed');
    });
    var price = item.price ;
    price +=  10;
   print(price);
  } catch (e) {
    print('exception caught');
  }


  //final productList = transform();
  //print(productList);
  final test = [1,3,6,7];



  //final total = test.fold(10, (int previousValue, element) => element +previousValue);
  //print(total);


  final allMeals = DUMMY_MEALS;
  final converted= allMeals.map((Meal meal) {
    return {
      "meal":meal
    };
  }).toList();
  print(converted);






  //get the first vegeterian meal
  final meal = allMeals.firstWhere((element) => element.vegetarian == true);

  final json= {
    'id':'1',
    'title':'red shirt',
    'description':'100 %Cotton shirt',
    'imageUrl':'instagram',
    'price':89
  };
  final p1= Product.fromJSON(json);

  //cas to the mixin
  p1 is Favourite? print('p1 is product'): print('p1 is NOT product');

}

 test(val1, int val2,Function(int,int) executor){
return executor(val1,val2);
}




  final allMeals = DUMMY_MEALS;
  final filter = {
    'isGlutenFree': true,
    'isLactoseFree': false,
    'isVegan': true,
    'isVegetarian': false,
  };
  //

  final meal = allMeals.firstWhere((element) => element.vegetarian == true);


  List<Meal> _filtered = allMeals.where((Meal meal) {
    if (filter['isGlutenFree']! && !meal.isGlutenFree) {
      return false;
    }
    if (filter['isLactoseFree']! && !meal.isLactoseFree) {
      return false;
    }
    if (filter['isVegan']! && !meal.isVegan) {
      return false;
    }
    if (filter['isVegetarian']! && !meal.isVegetarian) {
      return false;
    }
    return true;
  }).toList();

  print(_filtered);


final core= const CoreState();
//print(core);

final copy = core.copyWith(counter: 10);
print(copy.counter.hashCode);
print(copy.backgroundColor.hashCode);

//print(copy);
var val = 1 ^ 2;

print("core and copy is same: ${copy.counter.hashCode ^ copy.backgroundColor.hashCode}");

const categories =  DUMMY_CATEGORIES;
//print(categories);

final  filtered = categories.where((Category category){
  if(category.id == 'c1'){
    return true;
  }
  return false;
});
//print(filtered);
const test = [1,2,3,5];
final val = test.contains(2);
print(val);

const List<Meal> meals =  DUMMY_MEALS;
print(meals);

final matching = meals.where((Meal meal) {
 final categories =  meal.categoriesBelongTo;
 return categories.contains('c2');
}
).toList();

matching.forEach(print);
*/
}
