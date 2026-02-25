/// Base use case contract.
///
/// Every use case in the domain layer implements [UseCase] (or [UseCaseNoParams])
/// so the presentation layer can invoke them uniformly without knowing
/// implementation details.
///
/// Architecture decision: Use cases are the **single entry point** into
/// the domain layer from the presentation layer. They orchestrate calls
/// to repositories, apply domain rules, and return [Result].
library;

import 'package:ihsan_app/core/utils/result.dart';

/// A use case that requires parameters of type [Params].
abstract class UseCase<Type, Params> {
  FutureResult<Type> call(Params params);
}

/// A use case that requires no parameters.
abstract class UseCaseNoParams<Type> {
  FutureResult<Type> call();
}
