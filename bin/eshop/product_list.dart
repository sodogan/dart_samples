import 'product.dart';
import 'dart:collection';
import '../firebase/firebase_utility.dart' as firebase;

abstract class ListProvider {
  List<Product> _productList = [];

  void addProduct({
    required Product product,
  });

  void updateExistingProduct({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required double price,
  });

  removeProduct({required int index});
}

class ProductList extends ListProvider {
  UnmodifiableListView<Product> get productList =>
      UnmodifiableListView(_productList);

  UnmodifiableListView<Product> get favouriteProductList {
    return UnmodifiableListView(
      _productList.where((product) => product.isFavourite),
    );
  }

  @override
  Future<String> addProduct({
    required Product product,
  }) async {
//Need to use the firebaseutil
    try {
      final _id = await firebase.FirebaseUtility()
          .productFirebaseAsyncPost(data: product.toJson());
      //set the generated id
      final _newProduct = product.copyWith(newId: _id);
      _productList.add(_newProduct);
      return _id;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> fetchUserProducts(
      {required String authToken, required String userId}) async {
    try {
      final Map<String, dynamic> _products = await firebase.FirebaseUtility()
          .fetchAllProductsFirebaseAsync(authToken: authToken, userId: userId);

      //transform the data which is a Map of Maps
      _products.forEach((productID, value) {
        if (!findMatching(id: productID)) {
          value['id'] = productID;
          final _product = Product.fromJSON(value);
          _productList.add(_product);
        }
      });
    } catch (err) {
      rethrow;
    }
  }

  Future<void> fetchAllProducts({required String authToken}) async {
    try {
      final Map<String, dynamic> _products = await firebase.FirebaseUtility()
          .fetchAllProductsFirebaseAsync(authToken: authToken);

      //transform the data which is a Map of Maps
      _products.forEach((productID, value) {
        if (!findMatching(id: productID)) {
          value['id'] = productID;
          final _product = Product.fromJSON(value);
          _productList.add(_product);
        }
      });
    } catch (err) {
      rethrow;
    }
  }

  bool findMatching({required String id}) {
    return _productList.any((product) => product.id == id);
  }

  @override
  Future<void> updateExistingProduct({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required double price,
  }) async {
    print('Updating Product id: $id');
    //find the matching product!
    final _index =
        _productList.indexWhere((Product product) => product.id == id);
    assert(_index != -1, 'Failed to find the matching Product ID');

    final _jsonData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
    try {
      await firebase.FirebaseUtility()
          .updateFirebaseAsync(id: id, jsonData: _jsonData);

      //update the product
      _productList[_index] = Product(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          price: price);
    } catch (err) {
      rethrow;
    }
  }

  @override
  removeProduct({required int index}) async {
    assert(index != -1, 'Index can not be -1');
    final _product = productList[index];

    //removing an item
    try {
      await firebase.FirebaseUtility().deleteFirebaseAsync(id: _product.id);
      //remove the item

      _productList.removeAt(index);
    } catch (err) {
      rethrow;
    }
  }

  Product findFirsMatching({required String productID}) {
    return _productList.firstWhere((element) => element.id == productID);
  }
}
