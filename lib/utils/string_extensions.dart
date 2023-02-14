extension StringExtensions on String? {
  bool isBlankOrNull() {
    return this?.trim().isEmpty ?? true;
  }
}
