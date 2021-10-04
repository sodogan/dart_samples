import 'package:http/http.dart' as http;
import 'dart:convert';

import '../eshop/cart.dart';
import '../eshop/product.dart';
import '../exceptions/http_exception.dart';

class FirebaseUtility {
  static const productsFireBaseURL =
      'https://flutter-eshop-c6583-default-rtdb.firebaseio.com/products.json';
  static const ordersFireBaseURL =
      'https://flutter-eshop-c6583-default-rtdb.firebaseio.com/orders.json';

  static const fireBaseURL = 'flutter-eshop-c6583-default-rtdb.firebaseio.com';
  static const fireBaseProductsJsonPath = 'products.json';
  static const fireBaseOrdersJsonPath = 'orders.json';
  static const fireBaseCollection = 'products';
  static const _apiKey = 'AIzaSyAw5wSKdN7afzcdUvBh8_HucVoU_CgLFBo';
  final _signUpUrl = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey');
  final _signInUrl = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey');

  //SIGNUP
  Future<Map<String, dynamic>> signUpUser(
      {required String emailAddress, required String password}) async {
    //Now do a POST to the firebase.
    final _json = jsonEncode({
      'email': emailAddress,
      'password': password,
      'returnSecureToken': true
    });

    final response = await _authenticate(
        emailAddress: emailAddress, password: password, uri: _signUpUrl);
    return response;
  }

  Future<Map<String, dynamic>> _authenticate(
      {required String emailAddress,
      required String password,
      required Uri uri}) async {


    final _json = jsonEncode({
      'email': emailAddress,
      'password': password,
      'returnSecureToken': true
    });

    final response = await http.post(uri, body: _json);
    final _decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return _decoded;
    } else if (response.statusCode == 400 && _decoded['error'] != null) {
      final String _error_code = _decoded['error']['message'];
      String _error_msg;
      if (_error_code.contains('EMAIL_EXISTS')) {
        _error_msg = 'This email address already exists';
      } else if (_error_code.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        _error_msg = 'Too many attemps please try later';
      } else if (_error_code.contains('INVALID_PASSWORD')) {
        _error_msg = 'Wrong password';
      } else if (_error_code.contains('INVALID_EMAIL')) {
        _error_msg = 'Invalid email address';
      } else if (_error_code.contains('WEAK_PASSWORD')) {
        _error_msg = 'Weak password';
      } else if (_error_code.contains('INVALID_PASSWORD')) {
        _error_msg = 'Invalid password';
      } else if (_error_code.contains('EMAIL_NOT_FOUND')) {
        _error_msg = 'Email not found';
      } else {
        _error_msg = 'Unknown error';
      }
      throw HttpException(
        requestType: RequestType.post,
        message: _error_msg,
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    } else {
      throw HttpException(
        requestType: RequestType.post,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }

//SIGNIN
  @override
  Future<Map<String, dynamic>> signInUser(
      {required String emailAddress, required String password}) async {
    //Now do a POST to the firebase.
    final _json = jsonEncode({
      'email': emailAddress,
      'password': password,
      'returnSecureToken': true
    });
    final response = await _authenticate(
        emailAddress: emailAddress, password: password, uri: _signInUrl);
    return response;
  }

  //GET ALL
  Future<Map<String, dynamic>> fetchAllProductsFirebaseAsync(
      {String baseUrl = productsFireBaseURL, required String authToken, String? userId}) async {

    final url = userId ==null ? '$baseUrl?auth=$authToken': '$baseUrl?auth=$authToken&orderBy="userId"&equalTo="$userId"' ;

    final Uri _url = Uri.parse(url);

    print('Sending a GET request at $_url');

    final response = await http.get(_url);

    if (response.statusCode == 200 && response.body != "null") {
      final result = jsonDecode(response.body);
      return result;
    } else if (response.statusCode == 200 && response.body == "null") {
      throw HttpException(
        requestType: RequestType.get,
        message: 'No data is found ',
        stackTrace: StackTrace.fromString(
          response.statusCode.toString(),
        ),
      );
    } else {
      throw HttpException(
        requestType: RequestType.get,
        message: 'Failed with ${response.statusCode}',
        stackTrace: StackTrace.fromString(
          response.statusCode.toString(),
        ),
      );
    }
  }

//PATCH
  Future<dynamic> updateFirebaseAsync({
    String baseUrl = fireBaseURL,
    String? baseCollection = fireBaseCollection,
    required String id,
    required Map<String, dynamic> jsonData,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$baseCollection/$id.json');

    print('Sending a PATCH request at $_url');
    final response = await http.patch(_url, body: jsonEncode(jsonData));

    //This will be
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result);
      return result;
    } else {
      throw HttpException(
        requestType: RequestType.patch,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }

//POST
  Future<String> productFirebaseAsyncPost({
    String baseUrl = fireBaseURL,
    String? jsonPath = fireBaseProductsJsonPath,
    required Map<String, dynamic> data,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$jsonPath');

    print('Sending a POST request at $_url');
    final response = await http.post(_url, body: jsonEncode(data));

    //This will be
    if (response.statusCode == 200) {
      var _decoded = jsonDecode(response.body);
      final String id = _decoded['name'];
      print(id);
      return id;
    } else {
      throw HttpException(
        requestType: RequestType.post,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }


  //GET all the products
  Future<Map<String, dynamic>> fetchAllOrdersFirebaseAsync({
    String baseUrl = ordersFireBaseURL,
    required String idToken,
  }) async {
    final Uri _url = Uri.parse('$baseUrl?auth=$idToken');

    print('Sending a GET request at $_url');

    final response = await http.get(_url);

    //İn firebase if no data response.body return "null"
    //This will be-if there is no data then needs to throw exception too
    if (response.statusCode == 200 && response.body != "null") {
      return jsonDecode(response.body);
    } else if (response.statusCode == 200 && response.body == "null") {
      throw HttpException(
        requestType: RequestType.get,
        message: 'No data is found in',
        stackTrace: StackTrace.fromString(
          response.statusCode.toString(),
        ),
      );
    } else {
      //return Future.error(
      //    "This is the error", StackTrace.fromString("This is its trace"));
      throw HttpException(
        requestType: RequestType.get,
        message: 'Failed with ${response.statusCode}',
        stackTrace: StackTrace.fromString(
          'Ensure the path is correct',
        ),
      );
    }
  }


  //POST
  Future<String> orderFirebaseAsyncPost({
    String baseUrl = fireBaseURL,
    String? jsonPath = fireBaseOrdersJsonPath,
    required List<CartItem> cartItems,
    required double totalAmount,
    required DateTime dateTime,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$jsonPath');

    print('Sending a POST request at $_url');

    final _json = {
      'totalAmount': totalAmount,
      'dateTime': dateTime.toIso8601String(),
      'products': cartItems.map((item) {
        return {
          'productID': item.productID,
          'title': item.title,
          'description': item.description,
          'price': item.price,
        };
      }).toList()
    };
    print(_json);
    final response = await http.post(_url, body: jsonEncode(_json));

    //This will be
    if (response.statusCode == 200) {
      var _decoded = jsonDecode(response.body);
      final String id = _decoded['name'];
      print(id);
      return id;
    } else {
      throw HttpException(
        requestType: RequestType.post,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }

  //POST
  Future<dynamic> orderFirebaseAsyncGet({
    String baseUrl = fireBaseURL,
    String? jsonPath = fireBaseOrdersJsonPath,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$jsonPath');

    print('Sending a GET request at $_url');
    final response = await http.get(_url);

    //This will be
    if (response.statusCode == 200 && response.body != "null") {
      return jsonDecode(response.body);
    } else if (response.statusCode == 200 && response.body == "null") {
      throw HttpException(
        requestType: RequestType.get,
        message: 'No data is found in  ${jsonPath}',
        stackTrace: StackTrace.fromString(
          response.statusCode.toString(),
        ),
      );
    } else {
      //return Future.error(
      //    "This is the error", StackTrace.fromString("This is its trace"));
      throw HttpException(
        requestType: RequestType.get,
        message: 'Failed with ${response.statusCode}',
        stackTrace: StackTrace.fromString(
          'Ensure the path is correct',
        ),
      );
    }
  }

  //PATCH
  Future<dynamic> deleteFirebaseAsync({
    String baseUrl = fireBaseURL,
    String? baseCollection = fireBaseCollection,
    required String id,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$baseCollection/$id.json');

    print('Sending a DELETE request at $_url');
    final response = await http.delete(_url);

    //This will be
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result;
    } else {
      throw HttpException(
        requestType: RequestType.delete,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }

//POST Multple
  Future<String> postMultipleFirebaseAsync({
    String baseUrl = fireBaseURL,
    String? jsonPath = fireBaseProductsJsonPath,
    required List<Product> productList,
  }) async {
    final Uri _url = Uri.https(baseUrl, '/$jsonPath');

    print('Sending a POST request at $_url');

    final List<Map<String, dynamic>> resultList = productList.map((product) {
      return product.toJson();
    }).toList();

    final response = await http.post(_url, body: jsonEncode(resultList));

    //This will be
    if (response.statusCode == 200) {
      var _decoded = jsonDecode(response.body);
      final String id = _decoded['name'];
      print(id);
      return id;
    } else {
      throw HttpException(
        requestType: RequestType.post,
        message: 'Failed with exception}',
        stackTrace: StackTrace.fromString(
          'Return code: ${response.statusCode}',
        ),
      );
    }
  }
}
