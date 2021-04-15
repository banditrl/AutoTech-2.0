mixin Converters {
  Map<String, dynamic> convertDynamicToMap(dynamic object) {
    try {
      return object.toMap();
    } catch (error) {
      throw error;
    }
  }
}
