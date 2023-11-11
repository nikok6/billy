import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splitbill/screens/split_confirmation_screen.dart';
import 'package:splitbill/widgets/chip.dart';
import 'package:flutter/services.dart';

List<String> name = [
  'niko Doe',
  'daren Doe',
  'John Dot',
];

List<String> food = [
  'Chicken',
  'Beef',
  'Pork',
  'Fish',
];

class MainSplitScreen extends StatefulWidget {
  const MainSplitScreen(
      {super.key,
      required this.socialId,
      required this.total,
      required this.description});

  final String socialId;
  final String total;
  final String description;

  @override
  _MainSplitScreenState createState() => _MainSplitScreenState();
}

class _MainSplitScreenState extends State<MainSplitScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<List<TextEditingController>> _personShareTextController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    _personShareTextController = List.generate(
      name.length,
      (index) => List.generate(
        3,
        (index2) => TextEditingController(),
      ),
    );
    tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabIndex);
    tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  List<List<bool>> transposeFoodIsChecked(List<List<bool>> foodIsChecked) {
    int numberOfPeople = foodIsChecked.length;
    int numberOfFoods = foodIsChecked.isNotEmpty ? foodIsChecked[0].length : 0;

    List<List<bool>> transposedFoodIsChecked = List.generate(
        numberOfFoods,
        (foodIndex) => List.generate(numberOfPeople,
            (personIndex) => foodIsChecked[personIndex][foodIndex]));

    return transposedFoodIsChecked;
  }

  List<double> splitBills(List<String> food, List<double> foodPrice,
      List<List<bool>> foodIsChecked) {
    int numberOfPeople = foodIsChecked.length;

    // Initialize an array to store the total cost for each person
    List<double> personTotalCost = List.filled(numberOfPeople, 0.0);

    List<List<bool>> transposedFoodIsChecked = transposeFoodIsChecked(foodIsChecked);
    // Calculate the total cost for each person based on their chosen foods
    for (int personIndex = 0; personIndex < numberOfPeople; personIndex++) {
      for (int foodIndex = 0; foodIndex < food.length; foodIndex++) {
        if (foodIsChecked[personIndex][foodIndex]) {
          personTotalCost[personIndex] += foodPrice[foodIndex] /
              transposedFoodIsChecked[foodIndex]
                  .where((checked) => checked == true)
                  .length;
        }
      }
    }

    personTotalCost = personTotalCost.map((cost) => (double.parse(cost.toStringAsFixed(2)))).toList();

    if (sum(personTotalCost) < sum(foodPrice)) {
      // Calculate the remainder
      double remainder = double.parse(((sum(foodPrice) - sum(personTotalCost))*100).toStringAsFixed(2));
      personTotalCost = personTotalCost.map((cost) => (cost*100)).toList();
      // Distribute the remainder among persons
      int remainderCounter = 0;
      for (int i = 0; i < numberOfPeople; i++) {
        if (foodIsChecked[i].contains(true)) {
          personTotalCost[i] += remainderCounter < remainder ? 1 : 0;
          remainderCounter++;
        }
      }

      // Convert the shares to dollars
      personTotalCost = personTotalCost.map((cost) => (cost/100)).toList();
    }
    // Return the total cost for each person
    return personTotalCost;
  }

  double sum(List<double> numbers) {
    //convert list of string to list of double
    List<double> numbersDouble = numbers.map((i) => (i)).toList();
    return numbersDouble.reduce((value, element) => value + element);
  }

  List<double> splitMoneyEvenly(
      String total, List<String> names, List<bool> shouldSplit) {
    double totalAmount = double.parse(total);
    int numberOfPeople = names.length;

    int numberOfPeopleToSplit = shouldSplit.where((split) => split).length;
    int shareWithoutRounding = totalAmount * 100 ~/ numberOfPeopleToSplit;

    // Calculate the remainder
    int remainder = totalAmount.toInt() % numberOfPeopleToSplit;

    // Initialize personShares with 0 for those who shouldn't split, and shareWithoutRounding for others
    List<double> personShares = List.generate(numberOfPeople, (index) {
      return shouldSplit[index] ? shareWithoutRounding.toDouble() : 0;
    });
    // Distribute the remainder among persons
    // Distribute the remainder among persons who should split
    int remainderCounter = 0;
    for (int i = 0; i < numberOfPeople; i++) {
      if (shouldSplit[i]) {
        personShares[i] += remainderCounter < remainder ? 1 : 0;
        remainderCounter++;
      }
    }

    // Convert the shares to dollars
    personShares = personShares.map((cost) => (cost/100)).toList();

    return personShares;
  }

  int? _selectedValueIndex;
  double totalShare = 0;

  List<List<bool>> foodIsChecked = [
    [true, false, true, false],
    [false, true, false, false],
    [true, false, false, false],
  ];

  List<double> foodPrice = [10, 20, 30, 40];

  List<List<bool>> personIsChecked = [
    [true, true, true],
    [true, true, true],
    [true, true, true],
  ];

  List<List<double>> personCurrentShare = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
  ];

  Widget circle({required String text, required int index}) {
    return InkWell(
      splashColor: Colors.cyanAccent,
      onTap: () {
        setState(() {
          _selectedValueIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: CircleAvatar(
          backgroundColor:
              index == _selectedValueIndex ? Colors.blue : Colors.grey,
          radius: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: const [
            // ReusableChip(text: '+ Receipt'),
            SizedBox(width: 20),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(widget.description,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 15,
            ),
            Text("Total",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(
              "\$${widget.total}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 50,
                  ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // Text(
            //   "\$400 of \$500",
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
            // const SizedBox(
            //   height: 5,
            // ),
            // Text(
            //   "\$100 left",
            //   style: Theme.of(context).textTheme.bodyMedium,
            // ),
            const SizedBox(
              height: 25,
            ),
            //tab bar consists of 4 icons

            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TabBar(
                        labelPadding: const EdgeInsets.only(bottom: 10),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        dividerColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        unselectedLabelColor:
                            Theme.of(context).colorScheme.onSurface,
                        controller: tabController,
                        tabs: const [
                          Icon(Icons.fastfood_outlined),
                          Icon(Icons.numbers_outlined),
                          Icon(Icons.percent_outlined),
                          Icon(Icons.pie_chart_outline_rounded),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 600,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Split by item',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    ...List.generate(
                                      name.length,
                                      (index) => Card(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        child: SizedBox(
                                          width: 70,
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              circle(
                                                index: index,
                                                text: name[index],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                name[index],
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              Text(
                                                '\$${personCurrentShare[0][index].toStringAsFixed(2)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    //ListView of foods with a price and checkbox in the trailing
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: food.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                            horizontalTitleGap: 10,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                            leading: Text('1x',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  food[index],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    ...List.generate(
                                                      name.length,
                                                      (index2) => foodIsChecked[
                                                                      index2]
                                                                  [index] ==
                                                              true
                                                          ? const CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              radius: 10,
                                                            )
                                                          : const SizedBox(
                                                              width: 0,
                                                            ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            trailing: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    height: 24,
                                                    child: Checkbox(
                                                      side: const BorderSide(
                                                          color:
                                                              Color(0xFF666666),
                                                          width: 2),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      value: foodIsChecked[
                                                          _selectedValueIndex ??
                                                              0][index],
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          foodIsChecked[
                                                                  _selectedValueIndex ??
                                                                      0]
                                                              [index] = value!;
                                                          personCurrentShare[0] = splitBills(
                                                              food,
                                                              foodPrice,
                                                              foodIsChecked);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text('\$${foodPrice[index].toStringAsFixed(2)}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                ]));
                                      },
                                    ),
                                  ],
                                )
                                //itemized list
                                // Column(
                                //   children: [
                                //     ListView.builder(
                                //       itemBuilder:
                                //           (BuildContext context, int index) {
                                //         return ListTile(
                                //           horizontalTitleGap: 0,
                                //           contentPadding:
                                //               const EdgeInsets.fromLTRB(
                                //                   0, 0, 0, 0),
                                //           leading: Text('1x'),
                                //           title: Column(
                                //             children: [
                                //               Text("Niko"),
                                //               ...List.generate(
                                //                 foodIsChecked[index].length,
                                //                 (index2) => foodIsChecked[index][index2] == true ? const CircleAvatar(
                                //                   backgroundColor: Colors.blue,
                                //                   radius: 10,
                                //                 ) : const SizedBox(width: 0,),
                                //               ),
                                //             ],
                                //           ),
                                //           trailing: Column(children: [
                                //             Text('100'),
                                //             Checkbox(value: foodIsChecked[_selectedValueIndex ?? 0][index], onChanged: (bool? value) {
                                //               setState(() {
                                //                 foodIsChecked[_selectedValueIndex ?? 0][index] = value!;
                                //               });
                                //             },),
                                //           ],)
                                //         );
                                //       },
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Split by amount',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      ReusableChip(
                                          text: 'Split evenly',
                                          onPressed: () {
                                            setState(() {
                                              personCurrentShare[1] =
                                                  splitMoneyEvenly(widget.total,
                                                      name, personIsChecked[0]);
                                              for (int i = 0;
                                                  i < name.length;
                                                  i++) {
                                                _personShareTextController[0][i]
                                                        .text =
                                                    personCurrentShare[1][i]
                                                        .toString();
                                              }
                                            });
                                          })
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 500,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: name.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        horizontalTitleGap: 0,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                        leading: Checkbox(
                                          side: const BorderSide(
                                              color: Color(0xFF666666),
                                              width: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          value: personIsChecked[0][index],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              personIsChecked[0][index] =
                                                  value!;
                                              if (personIsChecked[0][index] ==
                                                  false) {
                                                _personShareTextController[0]
                                                        [index]
                                                    .text = '0.00';
                                              } else {
                                                _personShareTextController[0]
                                                        [index]
                                                    .text = '';
                                              }
                                            });
                                          },
                                        ),
                                        title: Row(
                                          children: [
                                            const Icon(Icons.circle_rounded,
                                                size: 60),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              name[index],
                                              style: personIsChecked[0][index]
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        trailing: SizedBox(
                                          width: 75,
                                          child: Row(
                                            children: [
                                              Text(
                                                '\$ ',
                                                style: personIsChecked[0]
                                                            [index] ==
                                                        true
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                            color: Colors.grey),
                                              ),
                                              SizedBox(
                                                width: 55,
                                                child: TextField(
                                                  enabled: personIsChecked[0]
                                                      [index],
                                                  controller:
                                                      _personShareTextController[
                                                          0][index],
                                                  textAlign: TextAlign.center,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d*\.?\d{0,2}')),
                                                  ],
                                                  style: personIsChecked[0]
                                                              [index] ==
                                                          true
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    border:
                                                        const UnderlineInputBorder(),
                                                    hintText: '',
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      personCurrentShare[1]
                                                              [index] =
                                                          double.parse(value);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Split by percentage',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      ReusableChip(
                                          text: 'Split evenly',
                                          onPressed: () {
                                            setState(() {
                                              personCurrentShare[2] =
                                                  splitMoneyEvenly(widget.total,
                                                      name, personIsChecked[1]);
                                              for (int i = 0;
                                                  i < name.length;
                                                  i++) {
                                                _personShareTextController[1][i]
                                                        .text =
                                                    (personCurrentShare[2][i] /
                                                            double.parse(
                                                                widget.total) *
                                                            100)
                                                        .toStringAsFixed(2);
                                              }
                                            });
                                          })
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 500,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: name.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        horizontalTitleGap: 0,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                        leading: Checkbox(
                                          side: const BorderSide(
                                              color: Color(0xFF666666),
                                              width: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          value: personIsChecked[1][index],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              personIsChecked[1][index] =
                                                  value!;
                                              if (personIsChecked[1][index] ==
                                                  false) {
                                                _personShareTextController[1]
                                                        [index]
                                                    .text = '0';
                                              } else {
                                                _personShareTextController[1]
                                                        [index]
                                                    .text = '';
                                              }
                                            });
                                          },
                                        ),
                                        title: Row(
                                          children: [
                                            const Icon(Icons.circle_rounded,
                                                size: 60),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name[index],
                                                  style: personIsChecked[1]
                                                          [index]
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey),
                                                ),
                                                Text(
                                                  '\$${double.parse(personCurrentShare[2][index].toStringAsFixed(2))}',
                                                  style: personIsChecked[1]
                                                          [index]
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: SizedBox(
                                          width: 75,
                                          child: Row(
                                            children: [
                                              // Text('\$ ', style: Theme.of(context).textTheme.titleLarge,),
                                              SizedBox(
                                                width: 50,
                                                child: TextField(
                                                  enabled: personIsChecked[1]
                                                      [index],
                                                  controller:
                                                      _personShareTextController[
                                                          1][index],
                                                  textAlign: TextAlign.center,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d*\.?\d{0,2}')),
                                                  ],
                                                  style: personIsChecked[1]
                                                          [index]
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    border:
                                                        const UnderlineInputBorder(),
                                                    hintText: '',
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      personCurrentShare[2]
                                                              [index] =
                                                          double.parse((double
                                                                      .parse(
                                                                          value) /
                                                                  100 *
                                                                  double.parse(
                                                                      widget
                                                                          .total))
                                                              .toStringAsFixed(
                                                                  2));
                                                    });
                                                  },
                                                ),
                                              ),
                                              Text(
                                                ' %',
                                                style: personIsChecked[1][index]
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                            color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Split by share',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      ReusableChip(
                                          text: 'Split evenly',
                                          onPressed: () {
                                            personCurrentShare[3] =
                                                splitMoneyEvenly(widget.total,
                                                    name, personIsChecked[2]);
                                            setState(() {
                                              for (int i = 0;
                                                  i < name.length;
                                                  i++) {
                                                if (personIsChecked[2][i]) {
                                                  _personShareTextController[2]
                                                          [i]
                                                      .text = '1';
                                                }
                                              }
                                            });
                                          })
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 500,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: name.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        horizontalTitleGap: 0,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                        leading: Checkbox(
                                          side: const BorderSide(
                                              color: Color(0xFF666666),
                                              width: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          value: personIsChecked[2][index],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              personIsChecked[2][index] =
                                                  value!;
                                              if (personIsChecked[2][index] ==
                                                  false) {
                                                _personShareTextController[2]
                                                        [index]
                                                    .text = '0';
                                              } else {
                                                _personShareTextController[2]
                                                        [index]
                                                    .text = '';
                                              }
                                            });
                                          },
                                        ),
                                        title: Row(
                                          children: [
                                            const Icon(Icons.circle_rounded,
                                                size: 60),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name[index],
                                                  style: personIsChecked[2]
                                                          [index]
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey),
                                                ),
                                                Text(
                                                  '\$${double.parse(personCurrentShare[3][index].toStringAsFixed(2))}',
                                                  style: personIsChecked[2]
                                                          [index]
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: SizedBox(
                                          width: 50,
                                          child: Row(
                                            children: [
                                              // Text('\$ ', style: Theme.of(context).textTheme.titleLarge,),
                                              SizedBox(
                                                width: 50,
                                                child: TextField(
                                                  enabled: personIsChecked[2]
                                                      [index],
                                                  controller:
                                                      _personShareTextController[
                                                          2][index],
                                                  textAlign: TextAlign.center,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d*\.?\d{0,2}')),
                                                  ],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    border:
                                                        const UnderlineInputBorder(),
                                                    hintText: '',
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      totalShare = 0;
                                                      for (int i = 0;
                                                          i < name.length;
                                                          i++) {
                                                        if (_personShareTextController[
                                                                2][i]
                                                            .text
                                                            .isNotEmpty) {
                                                          totalShare +=
                                                              double.parse(
                                                                  _personShareTextController[
                                                                          2][i]
                                                                      .text);
                                                        }
                                                      }
                                                      for (int i = 0;
                                                          i < name.length;
                                                          i++) {
                                                        if (_personShareTextController[
                                                                2][i]
                                                            .text
                                                            .isNotEmpty) {
                                                          personCurrentShare[3][
                                                              i] = (double.parse(
                                                                  _personShareTextController[
                                                                          2][i]
                                                                      .text) /
                                                              totalShare *
                                                              double.parse(
                                                                  widget
                                                                      .total));
                                                        }
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 70,
            width: 200,
            child: Card(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\$${sum(personCurrentShare[tabController.index]).toStringAsFixed(2)} of \$${widget.total}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "\$${(double.parse(widget.total) - sum(personCurrentShare[tabController.index])).toStringAsFixed(2)} left",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                )),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                if (double.parse((double.parse(widget.total) -
                            sum(personCurrentShare[tabController.index]))
                        .toStringAsFixed(2)) >
                    0) {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Error"),
                            content: const Text(
                                "Please make sure the split is equal to the total amount."),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"))
                            ],
                          ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplitConfirmationScreen()),
                  );
                }
              },
              child: const Text(
                "Done",
                style: TextStyle(fontWeight: FontWeight.w600),
              ))
        ]),
      ),
    );
  }
}
