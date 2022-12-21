String pathStandardIcons = 'assets/icons/';

DateTime beginningMonth(DateTime date) {
  return DateTime.utc(date.year, date.month, 1);
}

DateTime endMonth(DateTime date) {
  var end = DateTime.utc(date.year, date.month + 1).subtract(const Duration(days: 1));
  return DateTime.utc(end.year, end.month, end.day, 23, 59, 59);
}

String upperfirst(String text) {
  if (text.isEmpty) return text;
  return '${text[0].toUpperCase()}${text.substring(1)}';
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  return (!regex.hasMatch(value)) ? false : true;
}
