import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/setting_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DynamicColorSetting extends StatelessWidget {
  final BloomModel model;

  const DynamicColorSetting({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<BloomController>(context);
    return SettingWithIcon(
      icon: Icon(
        Symbols.palette_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dynamische Farben',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Farben des Systems nutzen',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: model.useDynamicColors,
              onChanged: (value) {
                controller.setUseDynamicColors(value);
              },
            ),
          ],
        ),
      ],
      onTap: () => controller.setUseDynamicColors(!model.useDynamicColors),
    );
  }
}
