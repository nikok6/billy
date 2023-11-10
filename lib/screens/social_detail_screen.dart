import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:splitbill/screens/choose_method_split_screen.dart';
import 'package:splitbill/widgets/button.dart';
import 'package:splitbill/widgets/card.dart';
import 'package:splitbill/widgets/summary_card.dart';
import 'package:http/http.dart' as http;

Future<List<Splits>> fetchSplits() async {
  final url = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'socialDetailsPage/history.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    //response is a list of json
    Iterable l = json.decode(response.body);
    return List<Splits>.from(l.map((model) => Splits.fromJson(model)));
  } else {
    throw Exception('Failed to load  splits');
  }
}

class Splits {
  final String billOwner;
  final String title;
  final List<dynamic> members;
  final int id;
  final int amountOwe;
  final int amountOwed;
  final List<dynamic> membersPaid;
  final String date;

  const Splits({
    required this.billOwner,
    required this.title,
    required this.members,
    required this.id,
    required this.amountOwe,
    required this.amountOwed,
    required this.membersPaid,
    required this.date,
  });

  factory Splits.fromJson(Map<String, dynamic> json) {
    return Splits(
      billOwner: json['billOwner'],
      title: json['title'],
      members: json['members'],
      membersPaid: json['membersPaid'],
      id: json['id'],
      amountOwe: json['amountOwe'],
      amountOwed: json['amountOwed'],
      date: json['date'],
    );
  }
}

class SocialDetailScreen extends StatefulWidget {
  const SocialDetailScreen({super.key, required this.socialId});

  final String socialId;

  @override
  State<SocialDetailScreen> createState() => _SocialDetailScreenState();
}

class _SocialDetailScreenState extends State<SocialDetailScreen> {
  late Future<List<Splits>> futureSplits;
  @override
  void initState() {
    super.initState();
    futureSplits = fetchSplits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: null,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 190,
        flexibleSpace: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),
            child: Column(
              children: [
                Row(children: [
                  const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Theme.of(context).colorScheme.onSurface,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  const SizedBox(width: 15),
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
                    SizedBox(
                      width: 25,
                    ),
                    SummaryCard(amountOwe: 30, amountOwed: 10, view: 'Social'),
                  ],
                ),
              ],
            ),
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   color: Theme.of(context).colorScheme.onSurface,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // )
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            // SizedBox(
            //     height: 195,
            //     child: Container(
            //       width: MediaQuery.of(context).size.width,
            //       decoration: BoxDecoration(
            //         color: Theme.of(context).colorScheme.surface,
            //         borderRadius: const BorderRadius.only(
            //           bottomLeft: Radius.circular(45),
            //           bottomRight: Radius.circular(45),
            //         ),
            //       ),
            //       child: Column(
            //         children: [
            //           Row(children: [
            //             const SizedBox(width: 25),
            //             const Icon(Icons.square_rounded, size: 60),
            //             const SizedBox(width: 15),
            //             Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Book Club',
            //                   overflow: TextOverflow.fade,
            //                   maxLines: 1,
            //                   softWrap: false,
            //                   style: Theme.of(context).textTheme.bodyLarge,
            //                 ),
            //                 Text('Dobil, Edward, and 2 more',
            //                     overflow: TextOverflow.fade,
            //                     maxLines: 1,
            //                     softWrap: false,
            //                     style: Theme.of(context).textTheme.bodyMedium),
            //               ],
            //             ),
            //           ]),
            //           const SizedBox(height: 5),
            //           const Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: [
            //               SizedBox(
            //                 width: 25,
            //               ),
            //               SummaryCard(
            //                   amountOwe: 30, amountOwed: 10, view: 'Social'),
            //             ],
            //           ),
            //         ],
            //       ),
            //     )),
            const SizedBox(height: 20),
            // ListView.builder(itemBuilder:
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: FutureBuilder(
                future: futureSplits,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 1400,
                      child: GroupedListView<dynamic, String>(
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        elements: snapshot.data,
                        groupBy: (element) => element.date,
                        groupComparator: (value1, value2) =>
                            value2.compareTo(value1),
                        // itemComparator: (item1, item2) =>
                        //     item1.title.compareTo(item2.title),
                        order: GroupedListOrder.DESC,
                        useStickyGroupSeparators: false,
                        stickyHeaderBackgroundColor:
                            Theme.of(context).colorScheme.background,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (c, element) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: element.amountOwe == 0
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  ReusableCard(
                                      texts: [element.billOwner, element.title],
                                      amount: element.amountOwe == 0
                                          ? element.amountOwed
                                          : element.amountOwe,
                                      countPaid: element.membersPaid.length,
                                      countTotal: element.members.length,
                                      style: element.amountOwe == 0 ? 2 : 1,
                                      index: 1,
                                      maxIndex: 5 - 1),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),

            // )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ReusableButton(onPressed: () {}, text: "Simplify expenses", styleId: 2),
            ReusableButton(onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChooseMethodSplitScreen(socialId: widget.socialId)),
                  );
            }, text: "Create new split", styleId: 1)
        ],),
      )
    );
  }
}
