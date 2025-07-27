import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/extensions/time_extensions.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/setting_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DailyResetTimeSetting extends StatelessWidget {
  final BloomModel model;

  const DailyResetTimeSetting({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<BloomController>(context);
    return SettingWithIcon(
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: model.dailyResetTime,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
          helpText: "Uhrzeit auswählen",
          confirmText: "Auswählen",
          cancelText: "Abbrechen",
        ).then((time) {
          if (time != null) {
            controller.setDailyResetTime(time);
          }
        });
      },
      icon: Icon(
        Symbols.early_on_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      children: [
        Text('Tagesbeginn', style: Theme.of(context).textTheme.bodyLarge),
        Text(
          model.dailyResetTime.to24hString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
