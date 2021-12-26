class DateTimeConverter{
  static String durationToNow(DateTime dateTime){
    final DateTime now = DateTime.now();
    final Duration duration = now.difference(dateTime);
    if (duration.inDays > 0) {
      return '${duration.inHours % 24}:${duration.inMinutes % 60}';
    } else {
      if (duration.inHours > 0) {
        return '${duration.inHours} giờ trước';
      } else {
        if(duration.inMinutes >= 1){
          return '${duration.inMinutes} phút trước';
        }
        else {
          return "Vừa xong";
        }
      }
    }


  }
}