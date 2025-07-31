import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/extensions/time_extensions.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/dialogs/duration_dialog.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/setting_with_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class BreakTimeMinSetting extends StatelessWidget {
  final BloomModel model;

  const BreakTimeMinSetting({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<BloomController>(context);
    return SettingWithIcon(
      onTap: () {
        showDurationDialog(context, model.breakTimeMin).then((duration) {
          if (duration != null) {
            if (duration.inMinutes < 1) {
              duration = const Duration(minutes: 1);
            }
            controller.setBreakTimeMin(duration);
          }
        });
      },
      icon: Icon(
        Symbols.coffee_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      children: [
        Text(
          "settings.min_break_time".tr(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          model.breakTimeMin.toPrettyStringShortest(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
