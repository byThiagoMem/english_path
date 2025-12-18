/// Result Pattern for handling success and failure cases
sealed class Result<T> {
  const Result();
}

/// Represents a successful result with data
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Represents a failed result with error message
class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;

  const Failure(this.message, [this.exception]);
}

/// Extension methods for Result
extension ResultExtension<T> on Result<T> {
  /// Returns true if this is a Success
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a Failure
  bool get isFailure => this is Failure<T>;

  /// Returns the data if Success, null otherwise
  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;

  /// Returns the error message if Failure, null otherwise
  String? get errorOrNull =>
      this is Failure<T> ? (this as Failure<T>).message : null;

  /// Fold pattern for handling both cases
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String message) onFailure,
  }) {
    return switch (this) {
      Success(data: final data) => onSuccess(data),
      Failure(message: final msg) => onFailure(msg),
    };
  }

  /// Execute callback based on result type
  void result(
    void Function(T data) onSuccess,
    void Function(Failure failure) onFailure,
  ) {
    switch (this) {
      case Success(data: final data):
        onSuccess(data);
      case Failure() as Failure<T>:
        onFailure(this as Failure<T>);
    }
  }
}
