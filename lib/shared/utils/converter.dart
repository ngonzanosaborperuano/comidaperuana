import 'package:json_annotation/json_annotation.dart';

class BoolToIntConverter implements JsonConverter<int?, dynamic> {
  const BoolToIntConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is bool) return json ? 1 : 0;
    if (json is int) return json;
    throw ArgumentError.value(
      json,
      'json',
      "Expected a bool (true/false) or int (1/0)",
    );
  }

  @override
  dynamic toJson(int? object) {
    if (object == null) return null;
    return object == 1;
  }
}

const boolIntConverter = BoolToIntConverter();
