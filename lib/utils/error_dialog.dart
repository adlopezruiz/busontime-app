import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void errorDialog(BuildContext context, CustomError e) {
  print('code: ${e.code}\nmessage: ${e.message}\nplugin: ${e.plugin}\n');

  if (Platform.isIOS) {
    showCupertinoDialog<dynamic>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(e.code),
          content: Text('${e.plugin}\n${e.message}'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } else {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: e.plugin,
      desc: e.message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.check,
      btnOkColor: AppColors.primaryGreen,
    ).show();
    // showDialog<dynamic>(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Text(e.code),
    //       content: Text('${e.plugin}\n${e.message}'),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
