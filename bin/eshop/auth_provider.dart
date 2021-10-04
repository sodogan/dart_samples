import '../firebase/firebase_utility.dart' as firebase;

class AuthProvider {
  String? _userID;
  String? _idToken;
  DateTime? _expiryDate;
  bool _isAuthenticated = false;

  String? get userID => _userID;
  String? get idToken => _idToken;
  DateTime? get expryDate=>_expiryDate;
  bool get isAuthenticated=>_isAuthenticated;

  /*
{
  "idToken": "[ID_TOKEN]",
  "email": "[user@example.com]",
  "refreshToken": "[REFRESH_TOKEN]",
  "expiresIn": "3600",
  "localId": "tRcfmLH7..."
}
*/
  Future<void> signIn(
      {required String emailAddress, required String password}) async {
// call the firebase
    try {
      final result = await firebase.FirebaseUtility()
          .signInUser(emailAddress: emailAddress, password: password);

      _parseResponse(result);
    } catch (err) {
      _isAuthenticated = false;
      rethrow;
    }
  }

  Future<void> signUp(
      {required String emailAddress, required String password}) async {
// call the firebase
    try {
      final result = await firebase.FirebaseUtility()
          .signUpUser(emailAddress: emailAddress, password: password);
      _parseResponse(result);
    } catch (err) {
      _isAuthenticated = false;
      rethrow;
    }
  }

  void _parseResponse(Map<String, dynamic> result) {
    //set
    _userID = result['localId'];
    _idToken = result['idToken'];
    final _seconds  = int.parse(result['expiresIn']);
    final _dateParsed = DateTime.now().add(Duration(seconds:_seconds ));
    _expiryDate = _dateParsed;
    _isAuthenticated = true;
  }
}
