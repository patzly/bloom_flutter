import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/setting_with_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class BrightnessSetting extends StatelessWidget {
  final BloomModel model;

  const BrightnessSetting({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final brightnessIcon = switch (model.brightnessLevel) {
      BrightnessLevel.auto => Symbols.routine_rounded,
      BrightnessLevel.light => Symbols.light_mode_rounded,
      BrightnessLevel.dark => Symbols.dark_mode_rounded,
    };

    return SettingWithIcon(
      icon: Icon(
        brightnessIcon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      children: [
        Text(
          'settings.brightness.title'.tr(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          'settings.brightness.description'.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        _buildToggleButtons(context),
      ],
    );
  }

  Widget _buildToggleButtons(BuildContext context) {
    final controller = BlocProvider.of<BloomController>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ToggleButtons(
        isSelected: List.generate(BrightnessLevel.values.length, (index) {
          return BrightnessLevel.values[index] == model.brightnessLevel;
        }),
        onPressed: (int index) {
          if (index == model.brightnessLevel.index) return;
          controller.setBrightnessLevel(BrightnessLevel.values[index]);
        },
        tapTargetSize: MaterialTapTargetSize.padded,
        borderRadius: BorderRadius.circular(24),
        borderColor: Theme.of(context).colorScheme.outlineVariant,
        selectedBorderColor: Theme.of(context).colorScheme.outlineVariant,
        selectedColor: Theme.of(context).colorScheme.onSecondaryContainer,
        fillColor: Theme.of(context).colorScheme.secondaryContainer,
        constraints: const BoxConstraints(
          minHeight: 40,
          maxHeight: 40,
          minWidth: 100,
        ),
        children: [
          Text(
            'settings.brightness.auto'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'settings.brightness.light'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'settings.brightness.dark'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
