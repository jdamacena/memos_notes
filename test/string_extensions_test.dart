import 'package:notes/utils/string_extensions.dart';
import 'package:test/test.dart';

void main() {
  test('Null should return true', () {
    String? string;

    expect(string.isBlankOrNull(), true);
  });

  test('String with only whitespace should return true', () {
    String? string = "         ";

    expect(string.isBlankOrNull(), true);
  });

  test('empty String should return true', () {
    String? string = "";

    expect(string.isBlankOrNull(), true);
  });

  test('Not empty String should return false', () {
    String? string = "not empty";

    expect(string.isBlankOrNull(), false);
  });

  test('String with whitespace around it should return false', () {
    String? string = "      i'm padded!       ";

    expect(string.isBlankOrNull(), false);
  });
}