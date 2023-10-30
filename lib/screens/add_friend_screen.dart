import 'package:flutter/material.dart';
import 'package:splitbill/widgets/button.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
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
      ),
      body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(25),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Add new friend",
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 20),
                    SizedBox(
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Input phone number',
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                        child: SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 25,
                              ),
                              const Icon(
                                Icons.circle_rounded,
                                size: 70,
                              ),
                              const SizedBox(width: 20),
                              Text("John Nicholas", style: Theme.of(context).textTheme.titleLarge),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ReusableButton(onPressed: () {}, text: "Add friend", styleId: 1),
                            ],
                          )
                        ],
                      ),
                    )),
                  ]))),
    );
  }
}
