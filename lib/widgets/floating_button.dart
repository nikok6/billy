//build a stateless widget with class named FloatingButton

import 'package:flutter/material.dart';
import 'package:splitbill/screens/add_group_split_screen.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'addSplit',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddGroupSplitScreen()),
        );
      },
      elevation: 20,
      extendedTextStyle: Theme.of(context).textTheme.bodyMedium,
      label: const Text('New Split'),
      icon: const Icon(Icons.add),
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      foregroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
