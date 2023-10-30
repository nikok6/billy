import 'package:flutter/material.dart';
import 'package:splitbill/screens/add_friend_screen.dart';
import 'package:splitbill/screens/create_new_group_screen.dart';
import 'package:splitbill/screens/see_all_social_screen.dart';
import 'package:splitbill/widgets/group_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Groups>> fetchGroups() async {
  final url = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'socialPage/groups.json');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    //response is a list of json
    Iterable l = json.decode(response.body);
    return List<Groups>.from(l.map((model) => Groups.fromJson(model)));
  } else {
    throw Exception('Failed to load recent transactions');
  }
}

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

class Groups {
  final String groupName;
  final int membersCount;

  const Groups({
    required this.groupName,
    required this.membersCount,
  });

  factory Groups.fromJson(Map<String, dynamic> json) {
    return Groups(
      groupName: json['name'],
      membersCount: json['membersCount'].toInt(),
    );
  }
}

class Friends {
  final String friendName;

  const Friends({
    required this.friendName,
  });

  factory Friends.fromJson(Map<String, dynamic> json) {
    return Friends(
      friendName: json['name'],
    );
  }
}

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  int _groupsCount = 6;
  int _friendsCount = 8;
  late Future<List<Groups>> futureGroups;
  late Future<List<Friends>> futureFriends;

  @override
  void initState() {
    super.initState();
    futureGroups = fetchGroups();
    futureFriends = fetchFriends();
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
        title: Text('Social', style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.fromLTRB(25, 5, 25, 20),
        child: Column(children: [
          //make a title called "Groups"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Groups', style: TextStyle(fontSize: 25)),
                ActionChip(
                  elevation: 0,
                  label: const Text("New group"),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateNewGroupScreen()),
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          //make a gridview of cards
          FutureBuilder<List<Groups>>(
              future: futureGroups,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.85,
                        ),
                        itemCount: _groupsCount > snapshot.data!.length
                            ? snapshot.data!.length
                            : _groupsCount,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                              width: 100,
                              height: 160,
                              child: GroupCard(
                                  text: snapshot.data![index].groupName,
                                  picture: "lntl"));
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: ActionChip(
                          label: const Text("See all"),
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceTint,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.surfaceTint,
                              width: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SeeAllSocialScreen(view: 'Groups')),
                            )
                          },
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),

          const SizedBox(height: 25),
          //make a title called "Friends"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Friends', style: TextStyle(fontSize: 25)),
                ActionChip(
                  elevation: 0,
                  label: const Text("Add friend"),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddFriendScreen()),
                    );
                  }
                )
                
              ],
            ),
          ),
          const SizedBox(height: 15),
          //make a gridview of cards

          FutureBuilder<List<Friends>>(
              future: futureFriends,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _friendsCount > snapshot.data!.length
                            ? snapshot.data!.length
                            : _friendsCount,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              const Icon(
                                Icons.circle_rounded,
                                size: 70,
                              ),
                              const SizedBox(height: 2.5),
                              Text(snapshot.data![index].friendName,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          );
                        },
                      ),
                      Center(
                        child: ActionChip(
                          label: const Text("See all"),
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceTint,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.surfaceTint,
                              width: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SeeAllSocialScreen(
                                          view: 'Friends')),
                            )
                          },
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ]),
      )),
    );
  }
}
