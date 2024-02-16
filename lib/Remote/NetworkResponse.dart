class NetworkResponse {
  NetworkResponseStatus responseStatus;
  String? responseTitle;
  String? responseDescription;
  String? responseBody;

  NetworkResponse({
    required this.responseStatus,
    this.responseTitle,
    this.responseDescription,
    this.responseBody,
  });
}

enum NetworkResponseStatus { success, alert, error, expiredToken }
