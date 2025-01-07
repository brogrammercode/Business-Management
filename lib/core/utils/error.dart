class CommonError {
  final String message;
  final String code;
  final String consoleMessage;

  const CommonError(
      {this.message = "Something went wrong, Please try again later",
      this.code = "",
      this.consoleMessage = ""});

  factory CommonError.initial() => const CommonError();
}

enum StateStatus { initial, loading, failure, success }
