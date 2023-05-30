import 'package:flutter/material.dart';

class Buttons {
  //Primary button atom
  static Widget primary({
    required VoidCallback onPressed,
    required String text,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(66, 155, 103, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  static Widget secondary({
    required VoidCallback onPressed,
    required String text,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(141, 149, 171, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
