import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  const Failure({required this.message, this.error, this.stackTrace});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final int statusCode;
  const ServerFailure({
    required this.statusCode,
    super.message = 'Something Went Wrong',
    super.error,
    super.stackTrace,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No Internet connection',
    super.error,
    super.stackTrace,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Unknown Error',
    super.error,
    super.stackTrace,
  });
}
