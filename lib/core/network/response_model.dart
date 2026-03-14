import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ResponseModel<T> {
  const ResponseModel({
    required this.code,
    required this.msg,
    this.data,
    this.pagination,
  });

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ResponseModelFromJson(json, fromJsonT);
  @JsonKey(defaultValue: 0)
  final int code;
  @JsonKey(defaultValue: '')
  final String msg;
  final T? data;
  final PaginationModel? pagination;

  /// Check if the business logic is correct
  bool get isSuccess => code == 0 || code == 200;
  Map<String, dynamic> toJson(T Function(T value) toJsonT) =>
      _$ResponseModelToJson(this, toJsonT);
}

/// Pagination data model
@JsonSerializable()
class PaginationModel {
  const PaginationModel({
    this.page = 1,
    this.size = 10,
    this.totalPage = 0,
    this.count = 0,
    this.hasNext = false,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
  final int page;
  final int size;
  @JsonKey(name: 'total_page')
  final int totalPage;
  final int count;
  @JsonKey(name: 'has_next')
  final bool hasNext;
  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
