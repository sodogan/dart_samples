import 'auth_provider.dart' as authentication;
import 'order.dart';
import 'product.dart';
import 'product_list.dart';
import 'cart.dart';

class FireBaseAuthTester {
  Future<authentication.AuthProvider> testSignIn() async {
    final authProvider = authentication.AuthProvider();

    try {
      await authProvider.signIn(
          emailAddress: 'solendogan@gmail.com', password: 'Taksim12');
      print('Auth token is ${authProvider.idToken}');
      print('User ID is ${authProvider.userID}');
      return authProvider;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> testSignUp() async {
    final authProvider = authentication.AuthProvider();

    try {
      await authProvider.signUp(
          emailAddress: 'solendogan@gmail.com', password: 'Taksim12');
      print('Auth token is ${authProvider.idToken}');
      print('User ID is ${authProvider.userID}');
    } catch (err) {
      rethrow;
    }
  }

  Future<void> testUserProductsFetch() async {
    final productListProvider = ProductList();
    //Now get the token from the auth
    try {
      //signin first
      final authProvider = await testSignIn();

      await productListProvider.fetchUserProducts(
          authToken: authProvider.idToken!, userId: authProvider.userID!);

      //the list of products fetched!
      print(productListProvider.productList);

      // await productListProvider.fetchAllProducts(authToken: authProvider.idToken!);
      //the list of products fetched!
      // print(productListProvider.productList);

    } catch (err) {
      rethrow;
    }
  }

  Future<void> testProductsPOST() async {

    final _product = dummyProduct;
    final productListProvider = ProductList();


    try {
      print('Before ${productListProvider.productList}');
      final id = await productListProvider.addProduct(product: _product);
      //should be added to the list now!
      print('After ${productListProvider.productList}');
    } catch (err) {
      rethrow;
    }


  }

  Future<void> testOrdersPOST() async{
    try {
      final _now = DateTime.now();
      final _mockOrder = setupOrderItem();
      final _orderListProvider = OrderListProvider();

      await _orderListProvider.addToOrderList(cartItems: _mockOrder.cartItems);

    } catch (err) {
     rethrow;
    }
  }
  OrderItem  setupOrderItem(){

      //create products
      final product1 = Product ( id: 'p1',title: 'green shirt',
          price: 11,
          description: 'a shirt',
          imageUrl: 'local');
      final product2 = Product(id: 'p2',title: 'black shirt',
          price: 3.78,
          description: 'a shirt',
          imageUrl: 'local');

      final product3 = Product(id: 'p3',title: 'Gray shirt',
          price: 3.78,
          description: 'a shirt',
          imageUrl: 'local');

      final product4 = Product(id: 'p4',title: 'Red shirt',
          price: 3.78,
          description: 'a shirt',
          imageUrl: 'local');

      List<CartItem> items = [
        CartItem(
            productID:product1.id,
            title: product1.title,
            description: product1.description,
            price: product1.price),
        CartItem(
            productID:product2.id,
            title: product2.title,
            description: product2.description,
            price: product2.price),
        CartItem(
            productID:product3.id,
            title: product3.title,
            description: product3.description,
            price: product3.price),
        CartItem(
            productID:product4.id,
            title: product4.title,
            description: product4.description,
            price: product4.price)
      ];

     final _orderItem = OrderItem(items, totalAmount: 12, dateTime: DateTime.now(),id: 'o1');
     return _orderItem;
    }




  Product get dummyProduct{
    return Product(
        id:DateTime.now().toString(),
        title: 'green shirt',
        price: 11,
        description: 'a shirt',
        imageUrl: 'local');
  }





}
