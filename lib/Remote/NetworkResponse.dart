class NetworkResponse {
  NetworkResponseStatus responseStatus;
  String? userMessage;
  String? responseBody;

  NetworkResponse({
    required this.responseStatus,
    this.userMessage,
    this.responseBody,
  });
}

enum NetworkResponseStatus { success, alert, error }
