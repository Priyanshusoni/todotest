import 'package:flutter/foundation.dart';

class ResponseModel {
  final bool status;
  final dynamic data;
  final String message;
  ResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  ResponseModel copyWith({bool? status, dynamic data, String? message}) {
    return ResponseModel(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      status: map['success'] == true,
      data: map['data'] ?? {},
      message: map['message'] as String? ?? (map['msg'] as String? ?? ''),
    );
  }

  String get getFormErrorMessage {
    if (status) return message;

    if (data is! Map) return message;

    final parseData = data as Map<String, dynamic>;

    for (final value in parseData.values) {
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }
    }
    return message;
  }

  @override
  String toString() =>
      'ResponseModel(status: $status, data: $data, message: $message)';

  @override
  bool operator ==(covariant ResponseModel other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        mapEquals(other.data, data) &&
        other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode ^ message.hashCode;
}
