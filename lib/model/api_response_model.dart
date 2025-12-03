class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.errorMessage,
    this.statusCode,
  });

  /// Create success response
  factory ApiResponse.success(T data) {
    return ApiResponse(
      success: true,
      data: data,
    );
  }

  /// Create error response
  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      success: false,
      errorMessage: message,
      statusCode: statusCode,
    );
  }
}
