/// Generic [Result] type using the Either pattern from `dartz`.
///
/// Every use case and repository method returns `Result<T>` so that
/// callers always handle both the failure path and the success path
/// explicitly — no uncaught exceptions leaking across architecture
/// boundaries.
///
/// ```dart
/// final result = await getOPrayerTimes(params);
/// result.fold(
///   (failure) => /* handle error */,
///   (prayerTimes) => /* handle success */,
/// );
/// ```
library;

import 'package:dartz/dartz.dart';
import 'package:ihsan_app/core/error/failures.dart';

/// A type alias that wraps [Either] with [Failure] on the left
/// and the success value [T] on the right.
typedef Result<T> = Either<Failure, T>;

/// A type alias for asynchronous results.
typedef FutureResult<T> = Future<Result<T>>;
