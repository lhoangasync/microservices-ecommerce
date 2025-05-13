class PageResponse<T> {
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalElements;
  final List<T> data;

  PageResponse({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalElements,
    required this.data,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PageResponse<T>(
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => fromJsonT(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'pageSize': pageSize,
      'totalElements': totalElements,
      'data': data.map((e) => toJsonT(e)).toList(),
    };
  }
}
