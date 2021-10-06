import '../bin/eshop/firebase_auth_tester.dart' as tester;
import 'eshop/product_list.dart';
import 'eshop/product.dart';
import 'exceptions/http_exception.dart';

void main(List<String> arguments) async {
  try {
    final _authTester = tester.FireBaseAuthTester();
//First test the Firebase signup
/* To test the sign-up
    final _authProvider = await _authTester.testSignUp(
      emailAddress: 'solendogan.sap@gmail.com',
      password: 'Taksim12',
    );

    print(_authProvider);
*/

    final _authProvider = await _authTester.testSignIn(
      emailAddress: 'solendogan@gmail.com',
      password: 'Taksim12',
    );

    print(_authProvider);

    if (_authProvider.isAuthenticated) {
      /*to get the users products
      final _list = await _authTester.testUserProductsFetch(
        idToken: _authProvider.idToken!,
        userID: _authProvider.userID!,
      );
      */
      final _list = await _authTester.testAllProductsFetch(
          idToken: _authProvider.idToken!);

      print(_list);
    }

    //Now trying to test the signin

  } on HttpException catch (exception) {
    print(exception);
  } catch (err) {
    print('Another exception occcured');
  }
}

Product get getAnyProduct {
  return Product(
      id: DateTime.now().toString(),
      title: 'blue blue shirt',
      price: 11,
      description: 'a shirt',
      imageUrl: 'local');
}
