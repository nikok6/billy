import 'package:flutter/material.dart';
import 'package:splitbill/widgets/button.dart';
import 'package:splitbill/widgets/dashed_line.dart';
import 'package:splitbill/widgets/half_circle_left.dart';
import 'package:splitbill/widgets/half_circle_right.dart';

class SplitConfirmationScreen extends StatefulWidget {
  const SplitConfirmationScreen({super.key, required this.data, required this.names, required this.total, required this.description});
  
  final List<double> data;
  final List<String> names;
  final String total;
  final String description;

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
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                surfaceTintColor: Theme.of(context).colorScheme.surface,
                elevation: 10,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                  child: Column(
                    children: [
                      Text(widget.description,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                                  children: [
                                    CustomPaint(
                                        size: const Size(30, 30),
                                        painter: HalfCircleLeft()),
                                    CustomPaint(
                                        size: const Size(283, 1),
                                        painter: DashedLinePainter()),
                                    CustomPaint(
                                        size: const Size(30, 30),
                                        painter: HalfCircleRight()),
                                  ],
                                ),
                                const SizedBox(height: 5),
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
                              title: Text(widget.names[index],
                                  style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,),
                              trailing: Text('\$${widget.data[index].toString()}',
                                  style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,),
                            );
                          }),
                          Row(
                                  children: [
                                    CustomPaint(
                                        size: Size(30, 30),
                                        painter: HalfCircleLeft()),
                                    CustomPaint(
                                        size: Size(283, 1),
                                        painter: DashedLinePainter()),
                                    CustomPaint(
                                        size: Size(30, 30),
                                        painter: HalfCircleRight()),
                                  ],
                                ),
                                const SizedBox(height: 15),
                          Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                      Text(
                                        "\$${widget.total}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
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
