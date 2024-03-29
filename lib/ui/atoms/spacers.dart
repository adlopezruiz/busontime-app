import 'package:flutter/material.dart';

class VerticalSpacer {
  static Widget regular() {
    return const SizedBox(
      height: 16,
    );
  }

  static Widget double() {
    return const SizedBox(
      height: 32,
    );
  }

  static Widget triple() {
    return const SizedBox(
      height: 64,
    );
  }
}

class HorizontalSpacer {
  static Widget regular() {
    return const SizedBox(
      width: 16,
    );
  }

  static Widget double() {
    return const SizedBox(
      width: 32,
    );
  }

  static Widget triple() {
    return const SizedBox(
      width: 64,
    );
  }
}
