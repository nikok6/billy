import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:splitbill/screens/confirm_scanned_receipt.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:splitbill/widgets/button.dart';

/// Print Long String
void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,32000}'); // 800 is the size of each chunk
  pattern
      .allMatches(text)
      .forEach((RegExpMatch match) => print(match.group(0)));
}

Future<String> convertImageto64(String imagePath) async {
  // print(imagePath);
  List<int> imageBytes = await File(imagePath).readAsBytes();
  String base64Image = base64Encode(imageBytes);
  // printLongString(base64Image);
  return base64Image;

  // final response = await http.post(
  //   Uri.parse('https://jsonplaceholder.typicode.com/albums'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   },
  //   body: jsonEncode(<String, String>{
  //     'title': '',
  //   }),
  // );

  // if (response.statusCode == 201) {
  //   // If the server did return a 201 CREATED response,
  //   // then parse the JSON.
  //   return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  // } else {
  //   // If the server did not return a 201 CREATED response,
  //   // then throw an exception.
  //   throw Exception('Failed to create album.');
  // }
}

// class Album {
//   final int id;
//   final String title;

//   const Album({required this.id, required this.title});

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       id: json['id'] as int,
//       title: json['title'] as String,
//     );
//   }
// }

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  final String imagePath;

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late Future<String> image64;

  @override
  void initState() {
    super.initState();
    image64 = convertImageto64(widget.imagePath);
    // print(image64.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.all(25),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(widget.imagePath)))),
          ReusableButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ConfirmedScannedReceiptScreen()));
              },
              text: 'Next',
              styleId: 1)
        ],
      ),
    );
  }
}
