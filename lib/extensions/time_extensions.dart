import 'package:flutter/material.dart';

extension DurationFormatting on Duration {
  String toPrettyStringShortest() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      if (minutes == 0 && seconds == 0) {
        return '$hours ${hours == 1 ? "Stunde" : "Stunden"}';
      } else if (seconds == 0) {
        return '$hours:${twoDigits(minutes)} ${hours == 1 && minutes == 0 ? "Stunde" : "Stunden"}';
      } else {
        return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)} ${hours == 1 && minutes == 0 && seconds == 0 ? "Stunde" : "Stunden"}';
      }
    } else if (minutes > 0) {
      if (seconds == 0) {
        return '$minutes ${minutes == 1 ? "Minute" : "Minuten"}';
      } else {
        return '$minutes:${twoDigits(seconds)} ${minutes == 1 && seconds == 0 ? "Minute" : "Minuten"}';
      }
    } else {
      return '$seconds ${seconds == 1 ? "Sekunde" : "Sekunden"}';
    }
  }

  String toPrettyStringRoundSecondsUp() {
    final totalSeconds = inSeconds;
    final roundedMinutes =
        ((totalSeconds + 59) ~/ 60).clamp(1, double.infinity).toInt();
    final hours = roundedMinutes ~/ 60;
    final minutes = roundedMinutes % 60;

    if (hours > 0) {
      if (minutes == 0) {
        return '$hours ${hours == 1 ? "Stunde" : "Stunden"}';
      } else {
        return '$hours:${minutes.toString().padLeft(2, '0')} ${hours == 1 && minutes == 0 ? "Stunde" : "Stunden"}';
      }
    } else {
      return '$roundedMinutes ${roundedMinutes == 1 ? "Minute" : "Minuten"}';
    }
  }

  String toPrettyStringRoundSecondsDown() {
    final totalSeconds = inSeconds;
    final roundedMinutes = (totalSeconds ~/ 60);
    final hours = roundedMinutes ~/ 60;
    final minutes = roundedMinutes % 60;

    if (hours > 0) {
      if (minutes == 0) {
        return '$hours ${hours == 1 ? "Stunde" : "Stunden"}';
      } else {
        return '$hours:${minutes.toString().padLeft(2, '0')} ${hours == 1 && minutes == 0 ? "Stunde" : "Stunden"}';
      }
    } else {
      return '$roundedMinutes ${roundedMinutes == 1 ? "Minute" : "Minuten"}';
    }
  }

  String toPrettyString(bool hideMinutes, bool hideSeconds) {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hideMinutes && hideSeconds) {
      return '$hours ${hours == 1 ? "Stunde" : "Stunden"}';
    } else if (hideSeconds) {
      if (hours > 0) {
        return '$hours:${twoDigits(minutes)} ${hours == 1 && minutes == 0 ? "Stunde" : "Stunden"}';
      } else {
        return '$minutes ${minutes == 1 ? "Minute" : "Minuten"}';
      }
    } else {
      if (hours > 0) {
        return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)} ${hours == 1 && minutes == 0 && seconds == 0 ? "Stunde" : "Stunden"}';
      } else if (minutes > 0) {
        return '$minutes:${twoDigits(seconds)} ${minutes == 1 && seconds == 0 ? "Minute" : "Minuten"}';
      } else {
        return '$seconds ${seconds == 1 ? "Sekunde" : "Sekunden"}';
      }
    }
  }
}

extension TimeOfDayFormatting on TimeOfDay {
  String to24hString() {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm Uhr';
  }
}
