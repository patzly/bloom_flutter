import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/services/foreground/phone_time_service.dart';
import 'package:bloom_flutter/services/foreground/phone_time_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PhoneTimeService _phoneTimeService = PhoneTimeServiceImpl.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneTimeService.init((Object data) {
        if (data is Map<String, dynamic>) {
          final timestampMillis = data["timestampMillis"];
          if (timestampMillis != null) {
            final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
              timestampMillis as int,
              isUtc: true,
            );
            print('timestamp: ${timestamp.toString()}');
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _phoneTimeService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BloomController, BloomModel>(
      builder: (context, model) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings'), centerTitle: true,),
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
          child: FilledButton.tonal(
            onPressed:
                model.isServiceRunning
                    ? () {
                      controller.stopService();
                    }
                    : null,
            child: Text('Stop service'),
          ),
        ),
      ],
    );
  }
}
