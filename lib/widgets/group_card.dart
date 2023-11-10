/*create  a card called ReusableCard which takes a few inputs:
1. list of texts
2. an integer
use the row widget to display the list of texts
at the bottom of the card, use the ReusableButton from button.dart */

import 'package:flutter/material.dart';
import 'package:splitbill/screens/social_detail_screen.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    Key? key,
    required this.text,
    required this.picture,
    required this.id,
  }) : super(key: key);

  final String text;
  final String picture;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SocialDetailScreen(socialId: id)),
        );
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          elevation: 10,
          shadowColor: Colors.black,
          child: SizedBox(
            width: 160,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.square_rounded,
                    size: 60,
                  ),
                  SizedBox(
                    width: 77,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
