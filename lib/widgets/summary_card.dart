import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    Key? key,
    required this.amountOwe,
    required this.amountOwed,
    required this.view,
  }) : super(key: key);

  final int amountOwe;
  final int amountOwed;
  final String view;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          surfaceTintColor: view == 'Home' ? Theme.of(context).colorScheme.surface : Colors.grey,
          elevation: 10,
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: SizedBox(
              width: 160,
              height: 94,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("You owe", style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 3),
                    Text('\$$amountOwe',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              )),
        ),
        Card(
          margin: const EdgeInsets.fromLTRB(10, 10, 25, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          surfaceTintColor: view == 'Home' ? Theme.of(context).colorScheme.surface : Colors.grey,
          elevation: 10,
          shadowColor: Colors.black,
          child: SizedBox(
              width: 160,
              height: 94,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("You're owed", 
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 3),
                    Text('\$$amountOwed',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
