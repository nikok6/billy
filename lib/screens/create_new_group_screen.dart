import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:splitbill/widgets/button.dart';

Future<List<Friends>> fetchFriends() async {
  final url = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'socialPage/friends.json');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    //response is a list of json
    Iterable l = json.decode(response.body);
    return List<Friends>.from(l.map((model) => Friends.fromJson(model)));
  } else {
    throw Exception('Failed to load recent transactions');
  }
}

class Friends {
  final String name;
  final String type;

  const Friends({
    required this.name,
    required this.type,
  });

  factory Friends.fromJson(Map<String, dynamic> json) {
    return Friends(
      name: json['name'],
      type: json['type'],
    );
  }
}

class CreateNewGroupScreen extends StatefulWidget {
  const CreateNewGroupScreen({super.key});

  @override
  State<CreateNewGroupScreen> createState() => _CreateNewGroupScreenState();
}

class _CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  late Future<List<Friends>> futureFriends;

  @override
  void initState() {
    super.initState();
    futureFriends = fetchFriends();
  }

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
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create a new group",
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 20),
                Card(
                    child: SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 25,
                      ),
                      const Icon(
                        Icons.square_rounded,
                        size: 70,
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 185,
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Group name',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 20),
                SizedBox(
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<Friends>>(
                    future: futureFriends,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Card(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          surfaceTintColor:
                              Theme.of(context).colorScheme.surface,
                          elevation: 10,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 25, 10),
                                      leading: const Icon(
                                        Icons.circle,
                                        size: 60,
                                      ),
                                      title: Text(
                                        snapshot.data![index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                      trailing: Checkbox(
                                        value: false,
                                        onChanged: (bool? value) {},
                                      ),
                                      onTap: () {},
                                    ),
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
                              }),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ReusableButton(
              text: 'Confirm',
              styleId: 1,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}
