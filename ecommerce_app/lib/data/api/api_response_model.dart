class ApiResponse<T> {
  final int code;
  final dynamic message;
  final String? error;
  final T? data;

  ApiResponse({required this.code, this.message, this.error, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] ?? 0,
      message: json['message'],
      error: json['error'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T? value) toJsonT) {
    return {
      'code': code,
      'message': message,
      'error': error,
      'data': data != null ? toJsonT(data) : null,
    };
  }
}
