import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<bool?> showPermissionDialog(BuildContext context) async {
  final controller = BlocProvider.of<BloomController>(context);
  bool hasPermission = await controller.hasNotificationPermission();
  if (hasPermission) {
    return false;
  }
  bool isDeniedPermanently =
      await controller.isNotificationPermissionDeniedPermanently();
  String msg =
      isDeniedPermanently
          ? 'Die Berechtigung wurde dauerhaft verweigert. Bitte erlaube Bloom das Anzeigen von Benachrichtigungen in den System-Einstellungen.'
          : 'Erlaube Bloom beim folgenden Dialog, Benachrichtigungen zum Erhalt des Hintergrundservices und zur Warnung vor Überschreiten deiner Zeitlimits anzuzeigen.';
  String action = isDeniedPermanently ? 'Schließen' : 'Weiter';
  return showDialog<bool>(
    context: context,
    animationStyle: AnimationStyle(
      duration: Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      reverseDuration: Duration(milliseconds: 200),
      reverseCurve: Curves.fastOutSlowIn,
    ),
    builder: (context) {
      return AlertDialog(
        title: Text("Berechtigung erforderlich"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      );
    },
  );
}
