import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splitbill/screens/main_split_screen.dart';
import 'package:splitbill/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:splitbill/widgets/dashed_line.dart';
import 'package:splitbill/widgets/half_circle_left.dart';
import 'package:splitbill/widgets/half_circle_right.dart';
import 'package:splitbill/widgets/modify_receipt_modal.dart';

Future<Receipt> fetchReceipt() async {
  final url = Uri.https(
      'dummy-billy-default-rtdb.asia-southeast1.firebasedatabase.app',
      'document/entities.json');
  print("fetching receipt");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    //response is a list of json
    List<dynamic> l = json.decode(response.body);
    print("receipt fetched");
    print(Receipt.fromJson(l));
    return Receipt.fromJson(l);
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
  String itemName;
  int itemCount;
  double itemPrice;
  double itemDiscount;
  double itemOtherCharges;

  Item({
    required this.itemName,
    required this.itemCount,
    required this.itemPrice,
    required this.itemDiscount,
    required this.itemOtherCharges,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonList = json['properties'];

    Map<String, dynamic> filteredItemMap = {
      'item_name': jsonList.where((e) => e['type'] == 'item_name').firstOrNull,
      'item_count':
          jsonList.where((e) => e['type'] == 'item_count').firstOrNull,
      'item_price':
          jsonList.where((e) => e['type'] == 'item_price').firstOrNull,
      'item_discount':
          jsonList.where((e) => e['type'] == 'item_discount').firstOrNull,
    };

    List<bool> emptyMap = filteredItemMap.values.map((e) => e == null).toList();

    return Item(
      itemName: emptyMap[0] == false
          ? filteredItemMap['item_name']['mentionText']
          : '',
      itemCount: emptyMap[1] == false
          ? int.parse(
              filteredItemMap['item_count']['normalizedValue']['text'] ?? '0')
          : 1,
      itemPrice: emptyMap[2] == false
          ? double.parse(filteredItemMap['item_price']['normalizedValue']
                      ['moneyValue']['units'] ??
                  '0') +
              ((filteredItemMap['item_price']['normalizedValue']['moneyValue']
                              ['nanos'] ??
                          0) /
                      1000000000 ??
                  0)
          : 0,
      itemDiscount: emptyMap[3] == false
          ? (double.parse(filteredItemMap['item_discount']['normalizedValue']
                      ['moneyValue']['units'] ??
                  '0') +
              ((filteredItemMap['item_discount']['normalizedValue']
                          ['moneyValue']['nanos'] ??
                      0) /
                  1000000000))
          : 0,
      itemOtherCharges: 0,
    );
  }
}

class Receipt {
  final String placeName;
  final Date date;

  final List<dynamic> item;

  final double tax;
  final double serviceCharge;
  double subtotal;
  double total;

  Receipt({
    required this.placeName,
    required this.date,
    required this.item,
    required this.tax,
    required this.serviceCharge,
    required this.subtotal,
    required this.total,
  });

  factory Receipt.fromJson(List<dynamic> json) {
    Map<String, dynamic> filteredMap = {
      'place_name': json.where((e) => e['type'] == 'place_name').firstOrNull,
      'date': json.where((e) => e['type'] == 'date').firstOrNull,
      'item': json.where((e) => e['type'] == 'item').toList(),
      'tax': json.where((e) => e['type'] == 'tax').firstOrNull,
      'service_charge':
          json.where((e) => e['type'] == 'service_charge').firstOrNull,
      'subtotal': json.where((e) => e['type'] == 'subtotal').firstOrNull,
      'total': json.where((e) => e['type'] == 'total').firstOrNull,
    };

    return Receipt(
      placeName: filteredMap['place_name'] != null
          ? filteredMap['place_name']['mentionText']
          : '',
      date: filteredMap['date'] != null
          ? Date.fromJson(filteredMap['date']['normalizedValue']['dateValue'])
          : Date(year: 0, month: 0, day: 0),
      item: filteredMap['item'] != null
          ? filteredMap['item'].map((entity) => Item.fromJson(entity)).toList()
          : [],
      tax: filteredMap['tax'] != null
          ? (double.parse(filteredMap['tax']['normalizedValue']['moneyValue']
                      ['units'])) +
                  ((filteredMap['tax']['normalizedValue']['moneyValue']
                              ['nanos'] ??
                          0) /
                      1000000000) ??
              0
          : 0,
      serviceCharge: filteredMap['service_charge'] != null
          ? (double.parse(filteredMap['service_charge']['normalizedValue']
                      ['moneyValue']['units'])) +
                  ((filteredMap['service_charge']['normalizedValue']
                              ['moneyValue']['nanos'] ??
                          0) /
                      1000000000) ??
              0
          : 0,
      subtotal: filteredMap['subtotal'] != null
          ? (double.parse(filteredMap['subtotal']['normalizedValue']
                      ['moneyValue']['units'])) +
                  ((filteredMap['subtotal']['normalizedValue']['moneyValue']
                              ['nanos'] ??
                          0) /
                      1000000000) ??
              0
          : 0,
      total: filteredMap['total'] != null
          ? (double.parse(filteredMap['total']['normalizedValue']['moneyValue']
                      ['units'])) +
                  ((filteredMap['total']['normalizedValue']['moneyValue']
                              ['nanos'] ??
                          0) /
                      1000000000) ??
              0
          : 0,
    );
  }
}

class ConfirmedScannedReceiptScreen extends StatefulWidget {
  const ConfirmedScannedReceiptScreen({super.key, required this.socialId});

  final String socialId;

  @override
  State<ConfirmedScannedReceiptScreen> createState() =>
      _ConfirmedScannedReceiptScreenState();
}

class _ConfirmedScannedReceiptScreenState
    extends State<ConfirmedScannedReceiptScreen> {
  late Future<Receipt> futureReceipt;

  @override
  void initState() {
    super.initState();
    futureReceipt = fetchReceipt();
  }

  void _update(int index, String itemName, int itemCount, double itemPrice) {
    setState(() {
      futureReceipt.then((value) => value.item[index].itemName = itemName);
      futureReceipt.then((value) => value.item[index].itemCount = itemCount);
      futureReceipt.then((value) => value.item[index].itemPrice = itemPrice);
      futureReceipt.then((value) => value.total = value.item.fold(
          0,
          (previousValue, element) =>
              previousValue + element.itemPrice + element.itemOtherCharges));
    });
  }

  void _newEntry(int index, String itemName, int itemCount, double itemPrice) {
    setState(() {
      futureReceipt.then((value) => value.item.add(Item(
          itemName: itemName,
          itemCount: itemCount,
          itemPrice: itemPrice,
          itemDiscount: 0,
          itemOtherCharges: 0)));
      futureReceipt.then((value) => value.total = value.item.fold(
          0,
          (previousValue, element) =>
              previousValue + element.itemPrice + element.itemOtherCharges));
    });
  }

  void _delete(int index) {
    setState(() {
      futureReceipt.then((value) => value.item.removeAt(index));
      futureReceipt.then((value) => value.total = value.item.fold(
          0,
          (previousValue, element) =>
              previousValue + element.itemPrice + element.itemOtherCharges));
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        break;
      case 'Delete':
        break;
    }
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
            const SizedBox(height: 20),
            FutureBuilder<Receipt>(
              future: futureReceipt,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  double itemSubtotal = 0;
                  int mostExpensive = 0;
                  double sumItemTotal = 0;
                  bool error = false;
                  for (int i = 0; i < snapshot.data!.item.length; i++) {
                    itemSubtotal += snapshot.data!.item[i].itemPrice;
                    if (snapshot.data!.item[i].itemPrice >
                        snapshot.data!.item[mostExpensive].itemPrice) {
                      mostExpensive = i;
                    }
                  }
                  for (int i = 0; i < snapshot.data!.item.length; i++) {
                    snapshot.data!.item[i].itemOtherCharges = double.parse(
                        ((snapshot.data!.item[i].itemPrice / itemSubtotal) *
                                (snapshot.data!.total - itemSubtotal))
                            .toStringAsFixed(2));
                    sumItemTotal += snapshot.data!.item[i].itemPrice +
                        snapshot.data!.item[i].itemOtherCharges;
                  }
                  if (double.parse(sumItemTotal.toStringAsFixed(2)) !=
                      double.parse(snapshot.data!.total.toStringAsFixed(2))) {
                    snapshot.data!.item[mostExpensive].itemOtherCharges += 0.01;
                    sumItemTotal += 0.01;
                  }
                  sumItemTotal = double.parse(sumItemTotal.toStringAsFixed(2));
                  if (double.parse(sumItemTotal.toStringAsFixed(2)) !=
                      double.parse(snapshot.data!.total.toStringAsFixed(2))) {
                    error = true;
                  }
                  snapshot.data!.subtotal = itemSubtotal;

                  return Column(
                    children: [
                      if (error)
                        Text(
                          "Error: Total does not match",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.red),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          surfaceTintColor:
                              Theme.of(context).colorScheme.surface,
                          elevation: 10,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                            child: Column(
                              children: [
                                Text(snapshot.data!.placeName,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.item.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Card(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 10),
                                                elevation: 0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // const SizedBox(height: 15),
                                                          Text(
                                                            snapshot
                                                                .data!
                                                                .item[index]
                                                                .itemName,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Text(
                                                            "x ${snapshot.data!.item[index].itemCount}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge,
                                                          ),
                                                        ]),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          InkWell(
                                                            child: const Icon(
                                                                Icons
                                                                    .more_horiz,
                                                                color: Color(
                                                                    0xFFDDDDDD)),
                                                            onTap: () {
                                                              showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ModifyReceiptModal(
                                                                      index:
                                                                          index,
                                                                      itemName: snapshot
                                                                          .data!
                                                                          .item[
                                                                              index]
                                                                          .itemName,
                                                                      itemQuantity: snapshot
                                                                          .data!
                                                                          .item[
                                                                              index]
                                                                          .itemCount
                                                                          .toString(),
                                                                      itemPrice: snapshot
                                                                          .data!
                                                                          .item[
                                                                              index]
                                                                          .itemPrice
                                                                          .toString(),
                                                                      function:
                                                                          _update,
                                                                      delete_function:
                                                                          _delete,
                                                                    );
                                                                  });
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "\$${(snapshot.data!.item[index].itemPrice).toStringAsFixed(2)}",
                                                            // "\$${(snapshot.data!.item[index].itemPrice + ((snapshot.data!.item[index].itemPrice / itemSubtotal) * (snapshot.data!.total - itemSubtotal))).toStringAsFixed(2)}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ]),
                                                  ],
                                                )),
                                            Divider(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                              thickness: 1,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25, 0, 25, 25),
                                        child: ReusableButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return ModifyReceiptModal(
                                                      index: snapshot
                                                          .data!.item.length,
                                                      itemName: '',
                                                      itemQuantity: '',
                                                      itemPrice: '',
                                                      function: _newEntry,
                                                      delete_function: _delete,
                                                    );
                                                  });
                                            },
                                            text: "Add more items",
                                            styleId: 1,
                                            icon: const Icon(
                                                Icons.add_circle_outline))),
                                  ],
                                ),
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
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Subtotal",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      Text(
                                        "\$${itemSubtotal.toStringAsFixed(2)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Others",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      Text(
                                        "\$${(snapshot.data!.total - itemSubtotal).toStringAsFixed(2)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
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
                                        "\$${snapshot.data!.total.toStringAsFixed(2)}",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReusableButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainSplitScreen(socialId: widget.socialId, total: snapshot.data!.total.toStringAsFixed(2), description: snapshot.data!.placeName)));
                                },
                                text: "Confirm",
                                styleId: 1),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 25),
          ]),
        ),
      ),
    );
  }
}
