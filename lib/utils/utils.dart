Map<String, String> stringifyMap(Map map) {
  return map.map((key, value) => MapEntry(key.toString(), value.toString()));
}

Map<String, String> stringifyMapAndRemoveIterables(Map map) {
  map.removeWhere((key, value) =>
  value is List || value is Map || value is Iterable || value is Set);

  return map.map((key, value) => MapEntry(key.toString(), value.toString()));
}
