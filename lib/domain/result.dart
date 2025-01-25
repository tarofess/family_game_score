sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T? value;
  const Success([this.value]);
}

class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;

  const Failure(this.message, [this.exception]);
}
