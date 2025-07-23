import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/setting_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ResetSetting extends StatelessWidget {
  final BloomModel model;

  const ResetSetting({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<BloomController>(context);
    return SettingWithIcon(
      onTap: () {
        showDialog<Duration>(
          context: context,
          animationStyle: AnimationStyle(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            reverseDuration: Duration(milliseconds: 200),
            reverseCurve: Curves.fastOutSlowIn,
          ),
          builder: (context) {
            return AlertDialog(
              title: const Text("Alles zurücksetzen?"),
              content: const Text('Möchtest du wirklich die gesamte App zurücksetzen? Dies kann nicht rückgängig gemacht werden.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () {
                    controller.reset();
                    Navigator.pop(context);
                  },
                  child: const Text('Zurücksetzen'),
                ),
              ],
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            );
          },
        );
      },
      icon: Icon(
        Symbols.reset_settings_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      children: [
        Text(
          'Alles zurücksetzen',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          'Kann nicht rückgängig gemacht werden',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
