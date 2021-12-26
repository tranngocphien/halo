String formatTime(DateTime created) {
  DateTime curTime = DateTime.now();
  String result = "";

  String day = created.day.toString();
  String month = created.month.toString();
  String hour = created.hour.toString();
  String second = created.second.toString();
  int difHours = curTime.difference(created).inHours;

  if (curTime.day - created.day > 7) {
    result = '$day th $month';
  } else if (difHours > 24 || curTime.day != created.day) {
    int weekday = created.weekday + 1;
    result = weekday != 8 ? 'T$weekday' : 'CN';
  } else {
    result = '$hour:$second';
  }
  return result;
}
