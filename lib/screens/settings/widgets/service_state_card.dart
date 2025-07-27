import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    ? "Hintergrundservice läuft"
                    : "Hintergrundservice läuft nicht",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                "Der Service ist für die Messung der Bildschirmzeit erforderlich und zeigt eine permanente Benachrichtigung mit niedriger Priorität an, um erhalten zu bleiben.",
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: () {
                    if (model.isServiceRunning) {
                      controller.stopService();
                    } else {
                      controller.initService().then((_) {
                        controller.startService();
                      });
                    }
                  },
                  child: Text(
                    model.isServiceRunning
                        ? "Service stoppen"
                        : "Service starten",
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
