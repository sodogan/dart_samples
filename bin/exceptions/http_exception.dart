enum RequestType{
  get,
  post,
  delete,
  patch
}

class HttpException implements Exception{
  final String message;
  final RequestType requestType;
  final StackTrace stackTrace;

  const HttpException({required this.requestType,required this.message,required this.stackTrace});


  @override
  String toString() {
    return 'For $requestType: $message->for more see stackTrace: $stackTrace' ;
  }


}