//Create a simple app that uses my button.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'package:splitbill/widgets/button.dart';
import 'package:splitbill/widgets/card.dart';
import 'package:splitbill/widgets/summary_card.dart';
import 'package:splitbill/widgets/transactions_card.dart';

import 'package:splitbill/widgets/floating_button.dart';
import 'package:http/http.dart' as http;

Future<Summary> fetchSummary() async {
  final url = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'Homepage/summary.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return Summary.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load summary');
  }
}

//create fetchOngoingSplits
Future<List<OngoingSplits>> fetchOngoingSplits(int mode) async {
  final url = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'Homepage/ongoingSplits.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    //response is a list of json
    Iterable l = json.decode(response.body);
    if (mode == 0) {
      return List<OngoingSplits>.from(
          l.map((model) => OngoingSplits.fromJson(model)));
    } else if (mode == 1) {
      return List<OngoingSplits>.from(
              l.map((model) => OngoingSplits.fromJson(model)))
          .where((element) => element.amountOwed > 0)
          .toList();
    } else if (mode == 2) {
      return List<OngoingSplits>.from(
              l.map((model) => OngoingSplits.fromJson(model)))
          .where((element) => element.amountOwe > 0)
          .toList();
    } else {
      return List<OngoingSplits>.from(
          l.map((model) => OngoingSplits.fromJson(model)));
    }
  } else {
    throw Exception('Failed to load ongoing splits');
  }
}

Future<List<RecentTransactions>> fetchRecentTransactions() async {
  final url = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'Homepage/lastTransactions.json');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    //response is a list of json
    Iterable l = json.decode(response.body);
    return List<RecentTransactions>.from(
        l.map((model) => RecentTransactions.fromJson(model)));
  } else {
    throw Exception('Failed to load recent transactions');
  }
}

class Summary {
  final int amountOwe;
  final int amountOwed;

  const Summary({
    required this.amountOwe,
    required this.amountOwed,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      amountOwe: json['owe'],
      amountOwed: json['owed'],
    );
  }
}

class OngoingSplits {
  final String billOwner;
  final String title;
  final List<dynamic> members;
  final int id;
  final int amountOwe;
  final int amountOwed;
  final List<dynamic> membersPaid;

  const OngoingSplits({
    required this.billOwner,
    required this.title,
    required this.members,
    required this.id,
    required this.amountOwe,
    required this.amountOwed,
    required this.membersPaid,
  });

  factory OngoingSplits.fromJson(Map<String, dynamic> json) {
    return OngoingSplits(
      billOwner: json['billOwner'],
      title: json['title'],
      members: json['members'],
      membersPaid: json['membersPaid'],
      id: json['id'],
      amountOwe: json['amountOwe'],
      amountOwed: json['amountOwed'],
    );
  }
}

class RecentTransactions {
  final String title;
  final int amount;
  final String date;

  const RecentTransactions({
    required this.title,
    required this.amount,
    required this.date,
  });

  factory RecentTransactions.fromJson(Map<String, dynamic> json) {
    return RecentTransactions(
      title: json['title'],
      amount: json['amountPaid'].toInt(),
      date: json['dateOfBill'],
    );
  }
}

bool _loading = true;
bool _ongoingSplitsLoading = true;

bool getLoading() {
  return _loading;
}

bool getOngoingSplitsLoading() {
  return _ongoingSplitsLoading;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Summary> futureSummary;
  late Future<List<OngoingSplits>> futureOngoingSplits,
      futureOngoingSplitsPaidbyYou,
      futureOngoingSplitsOwedbyYou;
  late Future<List<RecentTransactions>> futureRecentTransactions;

  int? _value = 0;
  List<String> chipsChoices = ['All', 'Paid by you', 'Owed by you'];

  @override
  void initState() {
    super.initState();
    futureSummary = fetchSummary();

    futureRecentTransactions = fetchRecentTransactions();
    futureOngoingSplits = fetchOngoingSplits(0);
    futureOngoingSplitsPaidbyYou = fetchOngoingSplits(1);
    futureOngoingSplitsOwedbyYou = fetchOngoingSplits(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: null,
        scrolledUnderElevation: 0,
        elevation: 0,
        leadingWidth: 150,
        leading: Row(
          children: [
            const SizedBox(width: 10),
            IconButton(
              icon: const ImageIcon(
                  AssetImage('lib/assets/images/grey-circle.png'),
                  size: 30),
              onPressed: () {},
            ),
            const Text('Janto', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const ImageIcon(AssetImage('lib/assets/images/bell.png'),
                size: 24),
            onPressed: () {},
            color: Theme.of(context).colorScheme.onBackground,
          ),
          IconButton(
            icon: const ImageIcon(AssetImage('lib/assets/images/setting.png'),
                size: 24),
            onPressed: () {},
            color: Theme.of(context).colorScheme.onBackground,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // use future builder to display the summary
                    FutureBuilder<Summary>(
                      future: futureSummary,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _loading = false;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //   "Good evening!",
                              //   style: TextStyle(fontSize: 23),
                              // ),
                              const SizedBox(height: 15),
                              Text("You have some unpaid bills!",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 3),
                              Text("Here is your summary:",
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              const SizedBox(height: 0),
                              SummaryCard(
                                amountOwe: snapshot.data!.amountOwe,
                                amountOwed: snapshot.data!.amountOwed,
                                view: 'Home',
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        //replace with fake data
                        return const Skeletonizer(
                          enabled: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Good evening!",
                              //   style: TextStyle(fontSize: 23),
                              // ),
                              SizedBox(height: 15),
                              Text("You have some unpaid bills!",
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(height: 3),
                              Text("Here is your summary:",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 0),
                              SummaryCard(
                                amountOwe: 100,
                                amountOwed: 200,
                                view: 'Home',
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // const SummaryCard(amountOwe: 200, amountOwed: 375),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              //ongoing splits cards
              FutureBuilder<List<OngoingSplits>>(
                future: _value == 0
                    ? futureOngoingSplits
                    : _value == 1
                        ? futureOngoingSplitsPaidbyYou
                        : futureOngoingSplitsOwedbyYou,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _ongoingSplitsLoading = false;
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 5),
                                  Text('Ongoing Splits',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  const SizedBox(width: 10),
                                  const ImageIcon(
                                    AssetImage(
                                        'lib/assets/images/arrow-circle-right.png'),
                                    size: 24,
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10.0,
                                children: List<Widget>.generate(
                                  3,
                                  (int index) {
                                    return ChoiceChip(
                                      label: Text(chipsChoices[index],
                                          style: _value == index
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                              : Theme.of(context)
                                                  .textTheme
                                                  .labelMedium),
                                      selected: _value == index,
                                      side: const BorderSide(width: 0),
                                      selectedColor:
                                          Theme.of(context).colorScheme.primary,
                                      disabledColor:
                                          Theme.of(context).colorScheme.surface,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                      showCheckmark: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      onSelected: (bool selected) {
                                        setState(() {
                                          _value = selected ? index : 0;
                                        });
                                      },
                                    );
                                  },
                                ).toList(),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: 227,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ReusableCard(
                                    texts: [
                                      snapshot.data![index].billOwner,
                                      snapshot.data![index].title
                                    ],
                                    amount: snapshot.data![index].amountOwe == 0
                                        ? snapshot.data![index].amountOwed
                                        : snapshot.data![index].amountOwe,
                                    countPaid: snapshot
                                        .data![index].membersPaid.length,
                                    countTotal:
                                        snapshot.data![index].members.length,
                                    style: snapshot.data![index].amountOwe == 0
                                        ? 2
                                        : 1,
                                    index: index,
                                    maxIndex: snapshot.data!.length - 1);
                              },
                            )),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Skeletonizer(
                    enabled: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 5),
                                  Text('Ongoing Splits',
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 10),
                                  ImageIcon(
                                    AssetImage(
                                        'lib/assets/images/arrow-circle-right.png'),
                                    size: 24,
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10.0,
                                children: List<Widget>.generate(
                                  3,
                                  (int index) {
                                    return ChoiceChip(
                                      label: Text(chipsChoices[index],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: _value == index
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          )),
                                      selected: _value == index,
                                      side: const BorderSide(width: 0),
                                      selectedColor: const Color(0xFF2C2C2C),
                                      backgroundColor: const Color(0xFF2C2C2C),
                                      showCheckmark: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      onSelected: (bool selected) {
                                        setState(() {
                                          _value = selected ? index : 0;
                                        });
                                      },
                                    );
                                  },
                                ).toList(),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: 227,
                            child: ReusableCard(
                                texts: ["Arvin", "Movieee Night"],
                                amount: 100,
                                countPaid: 3,
                                countTotal: 5,
                                style: 2,
                                index: 0,
                                maxIndex: 5)),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              //recent transactions title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 30),
                  Text('Recent Transactions',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: 10),
                  const ImageIcon(
                    AssetImage('lib/assets/images/arrow-circle-right.png'),
                    size: 24,
                  )
                ],
              ),

              const SizedBox(height: 15),

              //recent transactions card
              FutureBuilder<List<RecentTransactions>>(
                future: futureRecentTransactions,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Card(
                        margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        surfaceTintColor: Theme.of(context).colorScheme.surface,
                        elevation: 10,
                        child: SizedBox(
                          height: 409,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  (TransactionsCard(
                                    title: snapshot.data![index].title,
                                    date: snapshot.data![index].date,
                                    amount: snapshot.data![index].amount,
                                  )),
                                  Divider(
                                    height: 0,
                                    thickness: 1,
                                    indent: 20,
                                    endIndent: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ],
                              );
                            },
                          ),
                        ));
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
