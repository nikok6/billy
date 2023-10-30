import 'package:flutter/material.dart';

class ReusableChip extends StatelessWidget {
  final IconData? icon;
  final String text;

  const ReusableChip({Key? key, this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      side: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              labelStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
      avatar: icon != null ? Icon(icon) : null,
      label: Text(text),
    );
  }
}
