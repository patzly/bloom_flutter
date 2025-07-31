import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension DurationFormatting on Duration {
  String toPrettyStringShortest() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      if (minutes == 0 && seconds == 0) {
        return (hours == 1 ? 'time.hours' : 'time.hours_plural').tr(
          args: [hours.toString()],
        );
      } else if (seconds == 0) {
        String duration = '$hours:${twoDigits(minutes)}';
        return (hours == 1 && minutes == 0 ? 'time.hours' : 'time.hours_plural')
            .tr(args: [duration]);
      } else {
        String duration = '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
        return (hours == 1 && minutes == 0 && seconds == 0
                ? 'time.hours'
                : 'time.hours_plural')
            .tr(args: [duration]);
      }
    } else if (minutes > 0) {
      if (seconds == 0) {
        return (minutes == 1 ? 'time.minutes' : 'time.minutes_plural').tr(
          args: [minutes.toString()],
        );
      } else {
        String duration = '$minutes:${twoDigits(seconds)}';
        return (minutes == 1 && seconds == 0
                ? 'time.minutes'
                : 'time.minutes_plural')
            .tr(args: [duration]);
      }
    } else {
      return (seconds == 1 ? 'time.seconds' : 'time.seconds_plural').tr(
        args: [seconds.toString()],
      );
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
        return (hours == 1 ? 'time.hours' : 'time.hours_plural').tr(
          args: [hours.toString()],
        );
      } else {
        String duration = '$hours:${minutes.toString().padLeft(2, '0')}';
        return (hours == 1 && minutes == 0 ? 'time.hours' : 'time.hours_plural')
            .tr(args: [duration]);
      }
    } else {
      return (roundedMinutes == 1 ? 'time.minutes' : 'time.minutes_plural').tr(
        args: [roundedMinutes.toString()],
      );
    }
  }

  String toPrettyStringRoundSecondsDown() {
    final totalSeconds = inSeconds;
    final roundedMinutes = (totalSeconds ~/ 60);
    final hours = roundedMinutes ~/ 60;
    final minutes = roundedMinutes % 60;

    if (hours > 0) {
      if (minutes == 0) {
        return (hours == 1 ? 'time.hours' : 'time.hours_plural').tr(
          args: [hours.toString()],
        );
      } else {
        String duration = '$hours:${minutes.toString().padLeft(2, '0')}';
        return (hours == 1 && minutes == 0 ? 'time.hours' : 'time.hours_plural')
            .tr(args: [duration]);
      }
    } else {
      return (roundedMinutes == 1 ? 'time.minutes' : 'time.minutes_plural').tr(
        args: [roundedMinutes.toString()],
      );
    }
  }

  String toPrettyString(bool hideMinutes, bool hideSeconds) {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hideMinutes && hideSeconds) {
      return (hours == 1 ? 'time.hours' : 'time.hours_plural').tr(
        args: [hours.toString()],
      );
    } else if (hideSeconds) {
      if (hours > 0) {
        String duration = '$hours:${twoDigits(minutes)}';
        return (hours == 1 && minutes == 0 ? 'time.hours' : 'time.hours_plural')
            .tr(args: [duration]);
      } else {
        return (minutes == 1 ? 'time.minutes' : 'time.minutes_plural').tr(
          args: [minutes.toString()],
        );
      }
    } else {
      if (hours > 0) {
        String duration = '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
        return (hours == 1 && minutes == 0 && seconds == 0
                ? 'time.hours'
                : 'time.hours_plural')
            .tr(args: [duration]);
      } else if (minutes > 0) {
        String duration = '$minutes:${twoDigits(seconds)}';
        return (minutes == 1 && seconds == 0
                ? 'time.minutes'
                : 'time.minutes_plural')
            .tr(args: [duration]);
      } else {
        return (seconds == 1 ? 'time.seconds' : 'time.seconds_plural').tr(
          args: [seconds.toString()],
        );
      }
    }
  }
}

extension TimeOfDayFormatting on TimeOfDay {
  String to24hString() {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return 'time.time_hours_minutes'.tr(
      namedArgs: {'hours': hh, 'minutes': mm},
    );
  }
}
