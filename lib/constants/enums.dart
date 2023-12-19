enum AppFlavors { dev, prod, staging }

enum Status { init, loading, success, error }

//parses string into enum
T? enumFromString<T>(List enums, String? value) {
  if (value == null || enums.isEmpty) return null;

  for (var type in enums) {
    if (type.toString().split(".").last == value) return type;
  }
  return null;
}

extension EnumExtension on Enum {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
