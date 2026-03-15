import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_model.g.dart';

@JsonSerializable()
class ResponseModel {
  const ResponseModel({
    required this.code,
    required this.msg,
    this.data,
    this.pagination,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);
  @JsonKey(defaultValue: 0)
  final int code;
  @JsonKey(defaultValue: '')
  final String msg;
  final dynamic data;
  final PaginationModel? pagination;

  /// Check if the business logic is correct
  bool get isSuccess => code == 0 || code == 200;

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
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
