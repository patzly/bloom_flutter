import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:bloom_flutter/model/bloom_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceCard extends StatelessWidget {
  final BloomModel model;

  const ServiceCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<BloomController>(context);
    return Card.outlined(
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
                "Background service not running",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "The service is required for screen time measurement and displays a permanent low priority notification to stay alive.",
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: () {
                    controller.initService().then((_) {
                      controller.startService();
                    });
                  },
                  child: Text("Start service"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
