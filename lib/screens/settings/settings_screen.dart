import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/break_time_min_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/brightness_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/contrast_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/daily_reset_time_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/dynamic_color_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/screen_time_max_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/service_state_card.dart';
import 'package:bloom_flutter/screens/settings/widgets/session_time_max_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                SessionTimeMaxSetting(model: model),
                BreakTimeMinSetting(model: model),
                ScreenTimeMaxSetting(model: model),
                DailyResetTimeSetting(model: model),
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
