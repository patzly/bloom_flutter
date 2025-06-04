import 'package:bloom_flutter/screens/home/model/home_model.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final HomeModel model;

  const MainCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextBlock(
                  context,
                  'Your flower needs water!',
                  'Put your phone away for at least 10 minutes so that it gets sufficiently watered. Otherwise it will dry out in 2 minutes.',
                ),
                _buildTitleBlock(context, "Session time"),
                _buildTimeRow(context, '15 minutes', '15 minutes'),
                _buildProgressBar(context, 1.0),
                _buildExceededBlock(
                  context,
                  '2:35 minutes exceeded',
                  '5 minutes',
                  0.2,
                ),
                _buildTitleBlock(context, "Screen time"),
                _buildTimeRow(context, '30 minutes', '2 hours'),
                _buildProgressBar(context, 0.25),
                _buildChips(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBlock(
    BuildContext context,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(description),
        ],
      ),
    );
  }

  Widget _buildTitleBlock(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget _buildTimeRow(BuildContext context, String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [Text(left), Spacer(), Text(right, textAlign: TextAlign.end)],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 8,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        trackGap: 4,
        stopIndicatorColor: Theme.of(context).colorScheme.primary,
        stopIndicatorRadius: 2,
        year2023: false,
      ),
    );
  }

  Widget _buildExceededBlock(
    BuildContext context,
    String left,
    String right,
    double value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                left,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              Spacer(),
              Text(
                right,
                textAlign: TextAlign.end,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            color: Theme.of(context).colorScheme.error,
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            minHeight: 8,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            trackGap: 4,
            stopIndicatorColor: Theme.of(context).colorScheme.error,
            stopIndicatorRadius: 2,
            year2023: false,
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Chip(
            label: Text("2 days"),
            avatar: Icon(Icons.wb_sunny_rounded, color: Colors.amber.shade900),
            backgroundColor: Colors.amber.shade100,
          ),
          const SizedBox(width: 8),
          Chip(
            label: Text("2 drops of water"),
            avatar: Icon(
              Icons.water_drop_rounded,
              color: Colors.lightBlue.shade700,
            ),
            backgroundColor: Colors.lightBlue.shade100,
          ),
        ],
      ),
    );
  }
}
