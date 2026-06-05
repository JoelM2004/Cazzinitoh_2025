abstract class Failure {
  final String message;
  const Failure({this.message = 'Unknown error'});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error'});
}

class LocalFailure extends Failure {
  const LocalFailure({super.message = 'Local error'});
}