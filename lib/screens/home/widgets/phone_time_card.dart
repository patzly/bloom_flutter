import 'dart:math';

import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/extensions/time_extensions.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class PhoneTimeCard extends StatelessWidget {
  final BloomModel model;

  const PhoneTimeCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    print("Session time " + model.sessionTime.toString());
    return Card.outlined(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextBlock(
                  context,
                  'Deine Blume braucht Wasser!',
                  'Lege dein Smartphone für mindestens 10 Minuten weg, damit sie ausreichend gegossen wird. Ansonsten trocknet sie in 2 Minuten aus.',
                ),
                _buildTitleBlock(context, "Sitzungszeit"),
                _buildTimeRow(
                  context,
                  model.sessionTime.toPrettyString(false, true),
                  model.sessionTimeMax.toPrettyStringShortest(),
                ),
                _buildProgressBar(context, model.sessionTimeFraction),
                _buildExceededBlock(
                  context,
                  model.sessionTimeTolerance.toPrettyString(false, false) +
                      " überschritten",
                  Constants.sessionTimeToleranceMax.toPrettyStringShortest(),
                  model.sessionTimeToleranceFraction,
                ),
                _buildTitleBlock(context, "Bildschirmzeit"),
                _buildTimeRow(
                  context,
                  model.screenTime.toPrettyString(false, true),
                  model.screenTimeMax.toPrettyStringShortest(),
                ),
                _buildProgressBar(context, model.screenTimeFraction),
                _buildChips(
                  context,
                  model.daysStreak == 1 ? '1 Tag' : '${model.daysStreak} Tage',
                  model.waterDrops == 1
                      ? '1 Wassertropfen'
                      : '${model.waterDrops} Wassertropfen',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBlock(
    BuildContext context,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(description),
        ],
      ),
    );
  }

  Widget _buildTitleBlock(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget _buildTimeRow(BuildContext context, String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [Text(left), Spacer(), Text(right, textAlign: TextAlign.end)],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: LinearProgressIndicator(
        value: min(value, 1),
        minHeight: 8,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        trackGap: 4,
        stopIndicatorColor: Theme.of(context).colorScheme.primary,
        stopIndicatorRadius: 2,
        // ignore: deprecated_member_use for Material 3 appearance
        year2023: false, // Use Material 3 style
      ),
    );
  }

  Widget _buildExceededBlock(
    BuildContext context,
    String left,
    String right,
    double value,
  ) {
    if (value <= 0) {
      return SizedBox.shrink(); // Don't show if no exceeded time
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                left,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              Spacer(),
              Text(
                right,
                textAlign: TextAlign.end,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: min(value, 1),
            color: Theme.of(context).colorScheme.error,
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            minHeight: 8,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            trackGap: 4,
            stopIndicatorColor: Theme.of(context).colorScheme.error,
            stopIndicatorRadius: 2,
            // ignore: deprecated_member_use for Material 3 appearance
            year2023: false,
          ),
        ],
      ),
    );
  }

  Widget _buildChips(BuildContext context, String daysText, String dropsText) {
    final theme = Theme.of(context);

    final contrastLevel = switch (model.contrastLevel) {
      ContrastLevel.standard => 0.0,
      ContrastLevel.medium => 0.5,
      ContrastLevel.high => 1.0,
    };

    final yellowColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.yellow.harmonizeWith(theme.colorScheme.primary),
      brightness: theme.brightness,
      contrastLevel: contrastLevel,
    );
    final yellowThemeData = ThemeData(
      colorScheme: yellowColorScheme,
      splashColor: yellowColorScheme.primary.withAlpha((0.32 * 255).toInt()),
      textTheme: theme.textTheme,
      iconTheme: theme.iconTheme,
    );

    final blueColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue.harmonizeWith(theme.colorScheme.primary),
      brightness: theme.brightness,
      contrastLevel: contrastLevel,
    );
    final blueThemeData = ThemeData(
      colorScheme: blueColorScheme,
      splashColor: blueColorScheme.primary.withAlpha((0.32 * 255).toInt()),
      textTheme: theme.textTheme,
      iconTheme: theme.iconTheme,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Theme(
            data: yellowThemeData,
            child: ActionChip(
              label: Text(daysText),
              labelStyle: TextStyle(
                color: yellowColorScheme.onPrimaryContainer,
              ),
              avatar: Icon(
                Symbols.wb_sunny_rounded,
                color: yellowColorScheme.onPrimaryContainer,
                opticalSize: 18,
                weight: 550,
              ),
              backgroundColor: yellowColorScheme.primaryContainer,
              side: BorderSide(color: Colors.transparent, width: 0),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onPressed: () {
                // Handle tap
              },
            ), // Use SizedBox to avoid rendering issues
          ),
          const SizedBox(width: 8),
          Theme(
            data: blueThemeData,
            child: ActionChip(
              label: Text(dropsText),
              labelStyle: TextStyle(color: blueColorScheme.onPrimaryContainer),
              avatar: Icon(
                Symbols.water_drop_rounded,
                color: blueColorScheme.onPrimaryContainer,
                opticalSize: 18,
                weight: 550,
              ),
              backgroundColor: blueColorScheme.primaryContainer,
              side: BorderSide(color: Colors.transparent, width: 0),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
