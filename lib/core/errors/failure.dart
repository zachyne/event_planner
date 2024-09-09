class Failure {
  final String message;
  
  const Failure({required this.message});
}

class APIFailure extends Failure {
  final int statusCode; // http status codes: 404, 500
  const APIFailure({required super.message, required this.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class GeneralFailure extends Failure {
  const GeneralFailure({required super.message});
}
