//recent transactions card

import 'package:flutter/material.dart';

class TransactionsCard extends StatelessWidget {
  const TransactionsCard(
      {required this.title,
      required this.date,
      required this.amount,
      super.key});

  final String title;
  final String date;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 22.5,
        child: const Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
        overflow: TextOverflow.fade,
        maxLines: 1,
        softWrap: false,
      ),
      subtitle: Text(date,
          style: Theme.of(context).textTheme.labelSmall),
      trailing: Text(
        '\$$amount',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
