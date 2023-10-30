import 'package:flutter/material.dart';
import 'package:splitbill/widgets/button.dart';

class SplitConfirmationScreen extends StatefulWidget {
  const SplitConfirmationScreen({super.key});

  @override
  State<SplitConfirmationScreen> createState() =>
      _SplitConfirmationScreenState();
}

class _SplitConfirmationScreenState extends State<SplitConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 15, 25, 0),
          child: Column(children: [
            Text("Confirm your bill",
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 40),
            Card(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                surfaceTintColor: Theme.of(context).colorScheme.surface,
                elevation: 10,
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 25, 15, 0),
                  child: Column(
                    children: [
                      Text("Lunch at Tama",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Total",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      Text(
                        "\$500",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 40,
                            ),
                      ),
                      const SizedBox(height: 15),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: const Text("A"),
                              ),
                              title: Text("Name",
                                  style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,),
                              trailing: Text("\$100.00",
                                  style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,),
                            );
                          }),
                    ],
                  ),
                )),
             
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                ReusableButton(onPressed: () {
                  Navigator.pop(context);
                }, text: "Edit", styleId: 2),
                ReusableButton(onPressed: () {}, text: "Confirm", styleId: 1),
              ],),
    );
  }
}
