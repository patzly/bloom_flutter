import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/service_state_card.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/break_time_min_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/brightness_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/contrast_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/daily_reset_time_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/dynamic_color_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/reset_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/screen_time_max_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/settings/session_time_max_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BloomController, BloomModel>(
      builder: (context, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('settings.title'.tr()),
            centerTitle: true,
            elevation: 3,
            scrolledUnderElevation: 3,
            surfaceTintColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              icon: Icon(
                Symbols.arrow_back_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              tooltip: "settings.back".tr(),
              onPressed: () => Navigator.maybePop(context),
            ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ServiceStateCard(model: model),
                ),
                const SizedBox(height: 8),
                BrightnessSetting(model: model),
                ContrastSetting(model: model),
                DynamicColorSetting(model: model),
                SessionTimeMaxSetting(model: model),
                BreakTimeMinSetting(model: model),
                ScreenTimeMaxSetting(model: model),
                DailyResetTimeSetting(model: model),
                ResetSetting(model: model),
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
}
