import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:bloom_flutter/screens/settings/dialogs/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ServiceStateCard extends StatelessWidget {
  final BloomModel model;

  const ServiceStateCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<BloomController>(context);
    return Card.outlined(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.isServiceRunning
                    ? "settings.service_running".tr()
                    : "settings.service_not_running".tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text("settings.notification_info".tr()),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: () async {
                    if (model.isServiceRunning) {
                      controller.stopService();
                    } else {
                      // Check if notification permission is granted
                      final hasPermission =
                          await controller.hasNotificationPermission();
                      if (hasPermission) {
                        controller.startService();
                      } else {
                        bool? request = await showPermissionDialog(context);
                        if (request != null && request) {
                          bool granted =
                              await controller.requestNotificationPermission();
                          if (granted) {
                            // Start background service if permission is granted
                            controller.startService();
                          }
                        }
                      }
                    }
                  },
                  child: Text(
                    model.isServiceRunning
                        ? "settings.stop_service".tr()
                        : "settings.start_service".tr(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
