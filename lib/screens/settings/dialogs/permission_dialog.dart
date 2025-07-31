import 'package:bloom_flutter/controller/bloom_controller.dart';
import 'package:easy_localization/easy_localization.dart';
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
          ? 'permission.dialog_msg_denied'.tr()
          : 'permission.dialog_msg'.tr();
  String action =
      isDeniedPermanently ? 'actions.close'.tr() : 'actions.next'.tr();
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
        title: Text('permission.dialog_title'.tr()),
        content: Text(msg),
        actions: [
          if (!isDeniedPermanently)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('actions.cancel'.tr()),
            ),
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
