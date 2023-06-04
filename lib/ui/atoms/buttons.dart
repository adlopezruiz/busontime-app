import 'package:flutter/material.dart';

class Buttons {
  //Primary button atom
  static Widget primary({
    VoidCallback? onPressed,
    required Widget content,
    double? height,
    double? width,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(66, 155, 103, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: content,
      ),
    );
  }

  //Terciary is a gray button
  static Widget secondary({
    VoidCallback? onPressed,
    required Widget content,
    double? height,
    double? width,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(141, 149, 171, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: content,
      ),
    );
  }

  //Terciary is a white button
  static Widget terciary({
    VoidCallback? onPressed,
    required Widget content,
    double? height,
    double? width,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}
