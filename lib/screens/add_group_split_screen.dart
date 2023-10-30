import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:splitbill/screens/choose_method_split_screen.dart';
import 'package:splitbill/screens/create_new_group_screen.dart';
import 'dart:convert';

Future<List<GroupsAndFriends>> fetchGroupsAndFriends() async {
  final urlGroup = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'socialPage/groups.json');
  final urlFriend = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'socialPage/friends.json');
  final responseGroup = await http.get(urlGroup);
  final responseFriend = await http.get(urlFriend);
  if (responseGroup.statusCode == 200 && responseFriend.statusCode == 200) {
    //response is a list of json
    Iterable lGroup = json.decode(responseGroup.body);
    final listGroup = List<GroupsAndFriends>.from(
        lGroup.map((model) => GroupsAndFriends.fromJson(model)));
    Iterable lFriend = json.decode(responseFriend.body);
    final listFriend = List<GroupsAndFriends>.from(
        lFriend.map((model) => GroupsAndFriends.fromJson(model)));
    final listMerged = [...listFriend, ...listGroup];
    listMerged.sort((a, b) => a.name.compareTo(b.name));
    return listMerged;
  } else {
    throw Exception('Failed to load groups');
  }
}

class GroupsAndFriends {
  final String name;
  final String type;

  const GroupsAndFriends({
    required this.name,
    required this.type,
  });

  factory GroupsAndFriends.fromJson(Map<String, dynamic> json) {
    return GroupsAndFriends(
      name: json['name'],
      type: json['type'],
    );
  }
}

class AddGroupSplitScreen extends StatefulWidget {
  const AddGroupSplitScreen({super.key});

  @override
  State<AddGroupSplitScreen> createState() => _AddGroupSplitScreenState();
}

class _AddGroupSplitScreenState extends State<AddGroupSplitScreen> {
  late Future<List<GroupsAndFriends>> futureGroupsAndFriends;

  @override
  void initState() {
    super.initState();
    futureGroupsAndFriends = fetchGroupsAndFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Add Group Split'),
        // centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          ActionChip(
            elevation: 0,
            label: const Text("Create new group"),
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
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Who are you splitting with?",
                  style: Theme.of(context).textTheme.titleLarge),
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
              FutureBuilder<List<GroupsAndFriends>>(
                  future: futureGroupsAndFriends,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        surfaceTintColor: Theme.of(context).colorScheme.surface,
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
                                      leading:
                                          snapshot.data![index].type == 'group'
                                              ? const Icon(Icons.square_rounded,
                                                  size: 60)
                                              : const Icon(
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
                                      onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ChooseMethodSplitScreen()),
                                          );
                                        },),
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
    );
  }
}
