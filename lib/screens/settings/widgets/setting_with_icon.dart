import 'package:flutter/material.dart';

class SettingWithIcon extends StatelessWidget {
  final Icon icon;
  final List<Widget> children;

  const SettingWithIcon({
    super.key,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}
