extension Enums on String {
  /// Can convert either format: 'MyEnum.myvalue' or 'myvalue'
  T convertToEnum<T>(Iterable<T> values) {
    return values.firstWhere((type) => type.toString().split(".").last == this || type.toString() == this,
      orElse: () => null);
  }
}