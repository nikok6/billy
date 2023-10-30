import 'package:flutter/material.dart';

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

class BillDetailsScreen extends StatefulWidget {
  const BillDetailsScreen({super.key});

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
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
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child:Column(
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
                                            '1 of 4 paid',
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
                                    SizedBox(
                                      height: 500,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: name.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            horizontalTitleGap: 0,
                                            contentPadding: const EdgeInsets.fromLTRB(
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
                                                      textAlign: TextAlign.center,
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
              ),),
            ),
          ],
        )
    );
  }
}