import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/widgets/contrast_setting.dart';
import 'package:bloom_flutter/screens/settings/widgets/service_state_card.dart';
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
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BloomModel model) {
    final controller = BlocProvider.of<BloomController>(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          width: double.infinity,
          child: ServiceStateCard(model: model),
        ),
        const SizedBox(height: 16),
        ContrastSetting(model: model)
      ],
    );
  }
}
