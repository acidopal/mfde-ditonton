import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CaptureErrorUseCase {
  CaptureErrorUseCase(this.firebaseCrashlytics);

  final FirebaseCrashlytics firebaseCrashlytics;

  Future<Either<Failure, bool>> call(CaptureErrorParams params) async {
    try {
      await firebaseCrashlytics.recordError(
        params.exception,
        params.stackTrace as StackTrace?,
      );

      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class CaptureErrorParams {
  CaptureErrorParams(this.exception, this.stackTrace);

  final Object exception;
  final dynamic stackTrace;
}
