extension DurationFormatting on Duration {
  String toPrettyString() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      if (minutes == 0 && seconds == 0) {
        return '$hours ${hours == 1 ? "Stunde" : "Stunden"}';
      } else if (seconds == 0) {
        return '$hours:${twoDigits(minutes)} ${hours == 1 ? "Stunde" : "Stunden"}';
      } else {
        return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)} ${hours == 1 ? "Stunde" : "Stunden"}';
      }
    } else if (minutes > 0) {
      if (seconds == 0) {
        return '$minutes ${minutes == 1 ? "Minute" : "Minuten"}';
      } else {
        return '$minutes:${twoDigits(seconds)} ${minutes == 1 ? "Minute" : "Minuten"}';
      }
    } else {
      return '$seconds ${seconds == 1 ? "Sekunde" : "Sekunden"}';
    }
  }
}
