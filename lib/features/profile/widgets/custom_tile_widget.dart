import 'package:bot_main_app/ui/atoms/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    this.callback,
    required this.assetIcon,
    required this.labelText,
  });

  final VoidCallback? callback;
  final String assetIcon;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  assetIcon,
                  height: 50,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                labelText,
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
          const Icon(
            Icons.navigate_next,
            size: 38,
          ),
        ],
      ),
    );
  }
}
