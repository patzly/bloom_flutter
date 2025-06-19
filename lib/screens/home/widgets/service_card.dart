import 'package:bloom_flutter/screens/home/controller/home_controller.dart';
import 'package:bloom_flutter/screens/home/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceCard extends StatelessWidget {
  final HomeModel model;

  const ServiceCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = BlocProvider.of<HomeController>(context);
    return SizedBox(
      width: double.infinity,
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("hihu", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text("huhu"),
                  FilledButton.tonal(
                    onPressed: () {
                      controller.startService();
                    },
                    child: Text("Start"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
