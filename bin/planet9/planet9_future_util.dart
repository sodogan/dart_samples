import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'dart:io' show HttpHeaders;
import '../exceptions/http_exception.dart';

class Planet9FutureUtil {
  static const usersEndPoint = 'https://daimler.neptune-software.cloud/api/entity/users';
  static   const _authHeader = 'Basic YWRtaW46VGFrc2ltMTI=';

  //https://daimler.neptune-software.cloud/api/entity/users
  Future<List<dynamic>> fetchUsersPlanet9GET({String apiUrl = usersEndPoint}) async
  {
      final response = await http.get(
      Uri.parse(apiUrl),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: _authHeader,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw HttpException(
        requestType: RequestType.get,
        message: 'Failed with ${response.statusCode}',
        stackTrace: StackTrace.fromString(
          response.body.toString(),
        ),
      );
    }
  }
}
