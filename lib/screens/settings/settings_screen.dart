import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/extensions/time_extensions.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/dialogs/duration_dialog.dart';
import 'package:bloom_flutter/screens/settings/widgets/brightness_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/contrast_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/dynamic_color_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/service_state_card.dart';
import 'package:bloom_flutter/screens/settings/widgets/setting_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BloomController, BloomModel>(
      builder: (context, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Einstellungen'),
            centerTitle: true,
            elevation: 3,
            scrolledUnderElevation: 0,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BloomModel model) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                ServiceStateCard(model: model),
                const SizedBox(height: 8),
                BrightnessSetting(model: model),
                ContrastSetting(model: model),
                DynamicColorSetting(model: model),
                _buildSessionTimeMaxSetting(context, model),
                _buildBreakTimeMinSetting(context, model),
                _buildScreenTimeMaxSetting(context, model),
                _buildDailyResetTimeSetting(context, model),
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.bottom + 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionTimeMaxSetting(BuildContext context, BloomModel model) {
    final controller = BlocProvider.of<BloomController>(context);
    return SettingWithIcon(
      onTap: () {
        showDurationPicker(context, model.sessionTimeMax).then((duration) {
          if (duration != null) {
            if (duration.inMinutes < 1) {
              duration = const Duration(minutes: 1);
            }
            controller.setSessionTimeMax(duration);
          }
        });
      },
      icon: Icon(
        Symbols.hourglass_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      children: [
        Text(
          'Maximaldauer einer Sitzung',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          model.sessionTimeMax.toPrettyString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakTimeMinSetting(BuildContext context, BloomModel model) {
    final controller = BlocProvider.of<BloomController>(context);
    return SettingWithIcon(
      onTap: () {
        showDurationPicker(context, model.breakTimeMin).then((duration) {
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
          'Minimaldauer einer Pause',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          model.breakTimeMin.toPrettyString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildScreenTimeMaxSetting(BuildContext context, BloomModel model) {
    final controller = BlocProvider.of<BloomController>(context);
    return SettingWithIcon(
      onTap: () {
        showDurationPicker(context, model.screenTimeMax).then((duration) {
          if (duration != null) {
            if (duration.inMinutes < 1) {
              duration = const Duration(minutes: 1);
            }
            controller.setScreenTimeMax(duration);
          }
        });
      },
      icon: Icon(
        Symbols.mobile_hand_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      children: [
        Text(
          'Maximale Bildschirmzeit pro Tag',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          model.screenTimeMax.toPrettyString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyResetTimeSetting(BuildContext context, BloomModel model) {
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
