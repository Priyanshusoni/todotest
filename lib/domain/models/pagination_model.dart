// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:todo/core/utils/extension.dart';

class PaginationModel<T> {
  final List<T> data;
  final int total;
  final int skip;
  final int limit;

  PaginationModel({
    required this.data,
    required this.total,
    required this.skip,
    required this.limit,
  });

  PaginationModel<T> copyWith({
    List<T>? data,
    int? total,
    int? skip,
    int? limit,
  }) {
    return PaginationModel<T>(
      data: data ?? this.data,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }

  factory PaginationModel.init() {
    return PaginationModel<T>(data: [], total: 0, skip: 0, limit: 30);
  }

  factory PaginationModel.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    return PaginationModel<T>(
      data: (map['todos'] as List?)?.map((e) => fromMap(e)).toList() ?? [],
      total: map['total'] as int? ?? 0,
      skip: map['skip']?.toString().toInt() ?? 0,
      limit: map['limit'] as int? ?? 0,
    );
  }

  PaginationModel<T> addData(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    return PaginationModel<T>(
      data: [
        ...data,
        ...((map['todos'] as List?)?.map((e) => fromMap(e)).toList() ?? []),
      ],
      total: map['total'] as int? ?? 0,
      skip: map['skip']?.toString().toInt() ?? 0,
      limit: map['limit'] as int? ?? 0,
    );
  }

  @override
  String toString() {
    return 'PaginationModel(data: $data, total: $total, skip: $skip, limit: $limit)';
  }

  @override
  bool operator ==(covariant PaginationModel<T> other) {
    if (identical(this, other)) return true;

    return listEquals(other.data, data) &&
        other.total == total &&
        other.skip == skip &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return data.hashCode ^ total.hashCode ^ skip.hashCode ^ limit.hashCode;
  }
}
