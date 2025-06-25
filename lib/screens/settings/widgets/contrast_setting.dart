import 'package:bloom_flutter/constants.dart';
import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/setting_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ContrastSetting extends StatelessWidget {
  final BloomModel model;

  const ContrastSetting({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return SettingWithIcon(
      icon: Icon(
        Symbols.contrast_circle_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      children: [
        Text(
          'Kontrast',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          'Kann die Lesbarkeit bei Sehschwäche verbessern',
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
    return ToggleButtons(
      isSelected: List.generate(ContrastLevel.values.length, (index) {
        return ContrastLevel.values[index] == model.contrastLevel;
      }),
      onPressed: (int index) {
        if (index == model.contrastLevel.index) return;
        controller.setContrastLevel(ContrastLevel.values[index]);
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
      children: const [
        Text('Standard', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Mittel', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Hoch', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
