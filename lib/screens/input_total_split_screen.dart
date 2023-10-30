import 'package:flutter/material.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:splitbill/screens/main_split_screen.dart';

class InputTotalSplitScreen extends StatefulWidget {
  const InputTotalSplitScreen({super.key});

  @override
  State<InputTotalSplitScreen> createState() => _InputTotalSplitScreenState();
}

class _InputTotalSplitScreenState extends State<InputTotalSplitScreen> {
  late TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
      body: Container(
        margin: const EdgeInsets.fromLTRB(75, 175, 75, 25),
        child: Center(
          child: Column(
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              
              AutoSizeTextField(
                autofocus: true,
                fullwidth: false,
                controller: _textEditingController,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 30),
                decoration: InputDecoration(
                  prefixText: '\$',
                  border: InputBorder.none,
                  // hintText: '0',
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(height: 5.0),
              TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: Theme.of(context).textTheme.labelLarge,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                ),
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainSplitScreen()),
                  );
                },
                child: Text('Next',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
