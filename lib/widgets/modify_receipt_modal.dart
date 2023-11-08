import 'package:flutter/material.dart';
import 'package:splitbill/widgets/button.dart';

class ModifyReceiptModal extends StatefulWidget {
  ModifyReceiptModal(
      {Key? key,
      required this.index,
      required this.itemName,
      required this.itemQuantity,
      required this.itemPrice,
      required this.function,
      required this.delete_function})
      : super(key: key);
  
  final int index;
  String itemName;
  String itemQuantity;
  String itemPrice;
  final Function function;
  final Function delete_function;

  @override
  State<ModifyReceiptModal> createState() => _ModifyReceiptModalState();
}

class _ModifyReceiptModalState extends State<ModifyReceiptModal> {
  var controllerName = TextEditingController();
  var controllerQuantity = TextEditingController();
  var controllerPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text('Item name'),
                  ),
                  TextField(
                    controller: controllerName..text = widget.itemName,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter item name',
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text('Item quantity'),
                  ),
                  TextField(
                    controller: controllerQuantity
                      ..text = widget.itemQuantity,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter item count',
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text('Item price'),
                  ),
                  TextField(
                    controller: controllerPrice
                      ..text = widget.itemPrice,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter item price',
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ReusableButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, text: 'Cancel', styleId: 2),
                      const SizedBox(width: 10),
                      ReusableButton(
                          onPressed: () {
                            widget.delete_function(widget.index);
                            Navigator.pop(context);
                          }, text: 'Delete', styleId: 2),
                      const SizedBox(width: 10),
                      ReusableButton(
                          onPressed: () {
                            setState(() {
                              widget.itemName = controllerName.text;
                              widget.itemQuantity = controllerQuantity.text;
                              widget.itemPrice = controllerPrice.text;
                            });
                            print(widget.itemName);
                            widget.function(widget.index, widget.itemName, int.parse(widget.itemQuantity), double.parse(widget.itemPrice));
                            Navigator.pop(context);
                          }, text: 'Save', styleId: 1),
                      //delete button
                      
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
