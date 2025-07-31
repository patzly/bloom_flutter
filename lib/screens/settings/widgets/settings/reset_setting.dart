import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/setting_with_icon.dart';
import 'package:easy_localization/easy_localization.dart';
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
              title: Text("settings.reset.dialog_title".tr()),
              content: Text("settings.reset.dialog_msg".tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("actions.cancel".tr()),
                ),
                TextButton(
                  onPressed: () {
                    controller.reset();
                    Navigator.pop(context);
                  },
                  child: Text("actions.reset".tr()),
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
          "settings.reset.title".tr(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "settings.reset.description".tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
