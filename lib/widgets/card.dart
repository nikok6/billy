/*create  a card called ReusableCard which takes a few inputs:
1. list of texts
2. an integer
use the row widget to display the list of texts
at the bottom of the card, use the ReusableButton from button.dart */

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:splitbill/screens/bill_detail_screen.dart';
import 'package:splitbill/screens/home_screen.dart';
import 'package:splitbill/widgets/button.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard(
      {Key? key,
      required this.texts,
      required this.amount,
      required this.countPaid,
      required this.countTotal,
      required this.style,
      required this.index,
      required this.maxIndex})
      : super(key: key);

  final List<String> texts;
  final int amount;
  final int countPaid;
  final int countTotal;
  final int style;
  final int index;
  final int maxIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BillDetailsScreen()),
        );
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(
              index == 0 ? 25 : 0, 0, index == maxIndex ? 25 : 15, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          elevation: 10,
          shadowColor: Colors.black,
          child: SizedBox(
            width: 190,
            height: 228,
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'by ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const ImageIcon(
                          AssetImage('lib/assets/images/grey-circle.png'),
                          size: 16),
                      const Text(' '),
                      Text(
                        texts[0],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    texts[1],
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '\$$amount.00',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Skeleton.ignore(
                    child: LinearProgressIndicator(
                      value: countPaid / countTotal,
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '3d ago',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        ' $countPaid/$countTotal paid',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Skeleton.replace(
                      replace: getOngoingSplitsLoading(),
                      replacement: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(75, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ReusableButton(
                            text: style == 1 ? 'Pay' : 'Remind',
                            styleId: style == 1 ? 1 : 2,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
