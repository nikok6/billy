import 'package:flutter/material.dart';
import 'package:splitbill/main.dart';
import 'package:splitbill/widgets/summary_card.dart';

class SocialDetailScreen extends StatefulWidget {
  const SocialDetailScreen({super.key});

  @override
  State<SocialDetailScreen> createState() => _SocialDetailScreenState();
}

class _SocialDetailScreenState extends State<SocialDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shadowColor: null,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                  height: 195,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45),
                      ),
                    ),
                    child:
                    Column(children: [
                      Row(children: [
                        const SizedBox(width: 25),
                        const Icon(Icons.square_rounded, size: 60),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book Club',
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text('Dobil, Edward, and 2 more',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ]),
                      const SizedBox(height: 5),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width:25,),
                          SummaryCard(amountOwe: 30, amountOwed: 10, view: 'Social'),
                        ],
                      ),
                      ],)
                    ,)),
            const SizedBox(height: 20),
            // ListView.builder(itemBuilder: 

            // )
          ],
        ),
                
      ),
    );

}
}
