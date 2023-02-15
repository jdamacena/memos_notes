import 'package:notes/utils/datetime_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the date in the right format', () {
    String expectedResult = "Jan 24, 2020 at 01:28";
    DateTime dateTime = DateTime(2020, 01, 24, 1, 28);

    expect(DateTimeUtils.formatDateTime(dateTime), expectedResult);
  });

  test('Should return the time in the 24h format', () {
    DateTime dateTime = DateTime(2020, 01, 24, 16, 01);

    var formattedDateTime = DateTimeUtils.formatDateTime(dateTime);
    expect(formattedDateTime, endsWith("16:01"));
  });

  test('Should return the time with two digits minutes', () {
    DateTime dateTime = DateTime(2000, 1, 1, 12, 00);
    var formattedDateTime = DateTimeUtils.formatDateTime(dateTime);

    expect(formattedDateTime, endsWith("12:00"));
  });

  test('Should return the time with two digits hours', () {
    DateTime dateTime = DateTime(2000, 1, 1, 4, 30);
    var formattedDateTime = DateTimeUtils.formatDateTime(dateTime);

    expect(formattedDateTime, endsWith("04:30"));
  });

  test('Should return the month in abbreviated text', () {
    DateTime dateTime = DateTime(2000, 3, 1);
    var formattedDateTime = DateTimeUtils.formatDateTime(dateTime);

    expect(formattedDateTime.split(" ").first, "Mar");
  });
}
