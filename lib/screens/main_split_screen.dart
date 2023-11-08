

import 'package:flutter/material.dart';
import 'package:splitbill/screens/split_confirmation_screen.dart';
import 'package:splitbill/widgets/chip.dart';

List<String> name = [
  'John Doe',
  'Jane Doe',
  'John Dot',
];

List<bool> isChecked = [
  true,
  true,
  true,
];

class MainSplitScreen extends StatefulWidget {
  const MainSplitScreen({super.key});

  @override
  _MainSplitScreenState createState() => _MainSplitScreenState();
}

class _MainSplitScreenState extends State<MainSplitScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  int? _selectedValueIndex;
  List<String> people = ['niko', 'daren', 'john', 'wesley'];
  List<List<bool>> foodIsChecked = [
    [false, false, false, false],
    [false, false, false, false],
    [false, false, false, false],
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
            ReusableChip(text: '+ Receipt'),
            SizedBox(width: 20),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text("Lunch at Tama", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 15,
            ),
            Text("Total",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(
              "\$500",
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
                                      people.length,
                                      (index) => circle(
                                        index: index,
                                        text: people[index],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
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
                                          const ReusableChip(
                                              text: 'Split evenly')
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
                                              value: isChecked[index],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isChecked[index] = value!;
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
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                              ],
                                            ),
                                            trailing: SizedBox(
                                              width: 75,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '\$ ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                  SizedBox(
                                                    width: 55,
                                                    child: TextField(
                                                      enabled: isChecked[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            const UnderlineInputBorder(),
                                                        hintText: '',
                                                        hintStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .titleLarge,
                                                      ),
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
                                          const ReusableChip(
                                              text: 'Split evenly')
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
                                              value: isChecked[index],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isChecked[index] = value!;
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
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge,
                                                    ),
                                                    Text(
                                                      '\$100',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall,
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            const UnderlineInputBorder(),
                                                        hintText: '',
                                                        hintStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .titleLarge,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' %',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
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
                                          const ReusableChip(
                                              text: 'Split evenly')
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
                                              value: isChecked[index],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isChecked[index] = value!;
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
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge,
                                                    ),
                                                    Text(
                                                      '\$100',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall,
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            const UnderlineInputBorder(),
                                                        hintText: '',
                                                        hintStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .titleLarge,
                                                      ),
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
                      "\$400 of \$500",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "\$100 left",
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SplitConfirmationScreen()),
                );
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
