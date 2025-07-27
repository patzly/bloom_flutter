import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Duration?> showDurationPicker(
  BuildContext context,
  Duration initialDuration,
) async {
  int initialHours = initialDuration.inHours;
  int initialMinutes = initialDuration.inMinutes % 60;

  int selectedHours = initialHours;
  int selectedMinutes = (initialMinutes ~/ 5) * 5;

  return showDialog<Duration>(
    context: context,
    animationStyle: AnimationStyle(
      duration: Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      reverseDuration: Duration(milliseconds: 200),
      reverseCurve: Curves.fastOutSlowIn,
    ),
    builder: (context) {
      return AlertDialog(
        title: const Text("Dauer auswählen"),
        content: SizedBox(
          height: 150,
          child: Row(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedHours,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) => selectedHours = index,
                  children: List.generate(
                    24,
                    (i) => Center(child: Text('$i h')),
                  ),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedMinutes ~/ 5,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) => selectedMinutes = index * 5,
                  children: List.generate(
                    12,
                    (i) => Center(child: Text('${i * 5} min')),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed:
                () => Navigator.pop(
                  context,
                  Duration(hours: selectedHours, minutes: selectedMinutes),
                ),
            child: const Text('Auswählen'),
          ),
        ],
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      );
    },
  );
}
