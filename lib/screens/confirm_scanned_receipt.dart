import 'dart:core';

import 'package:flutter/material.dart';
import 'package:splitbill/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Receipt> fetchReceipt() async {
  final url = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'document.json');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    //response is a list of json
    List<dynamic> l = json.decode(response.body);
    print(Receipt.fromJson(l.first).toString());
    return Receipt.fromJson(l.first);
  } else {
    throw Exception('Failed to load recent transactions');
  }
}

class Date {
  int year;
  int month;
  int day;

  Date({required this.year, required this.month, required this.day});

  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(
      year: json['year'],
      month: json['month'],
      day: json['day'],
    );
  }
}

class Item {
  final String itemName;
  final int itemCount;
  final double itemPrice;
  final double itemDiscount;

  const Item({
    required this.itemName,
    required this.itemCount,
    required this.itemPrice,
    required this.itemDiscount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['item_name'],
      itemCount: json['item_count'].toInt(),
      itemPrice: json['item_price'].toDouble(),
      itemDiscount: json['item_discount'].toDouble(),
    );
  }
}

class Receipt {
  final String placeName;
  final Date date;

  final List<Item> item;

  final double tax;
  final double serviceCharge;
  final double subtotal;
  final double total;

  const Receipt({
    required this.placeName,
    required this.date,
    required this.item,
    required this.tax,
    required this.serviceCharge,
    required this.subtotal,
    required this.total,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    final itemEntities =
        json['entities'].where((entity) => entity['type'] == 'item');
    return Receipt(
      placeName: json['entities']['place_name'] ?? '',
      date: Date.fromJson(
          json['entities'].firstWhere((entity) => entity['type'] == 'date',
              orElse: () => {
                    'normalizedValue': {'dateValue': {}}
                  })['normalizedValue']['dateValue']),
      item: itemEntities.map((entity) => Item.fromJson(entity)).toList(),
      tax: json['entities']['tax'].toDouble() ?? 0,
      serviceCharge: json['entities']['service_charge'].toDouble() ?? 0,
      subtotal: json['entities']['subtotal'].toDouble() ?? 0,
      total: json['entities']['total'].toDouble() ?? 0,
    );
  }
}

class ConfirmedScannedReceiptScreen extends StatefulWidget {
  const ConfirmedScannedReceiptScreen({super.key});

  @override
  State<ConfirmedScannedReceiptScreen> createState() =>
      _ConfirmedScannedReceiptScreenState();
}

class _ConfirmedScannedReceiptScreenState
    extends State<ConfirmedScannedReceiptScreen> {
  late Future<Receipt> receipt;

  @override
  void initState() {
    super.initState();
    receipt = fetchReceipt();
  }

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
            Text("Confirm your scanned receipt",
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
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
                              title: Text(
                                "Name",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Text(
                                "\$100.00",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }),
                    ],
                  ),
                )),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ReusableButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Edit",
              styleId: 2),
          ReusableButton(onPressed: () {}, text: "Confirm", styleId: 1),
        ],
      ),
    );
  }
}
