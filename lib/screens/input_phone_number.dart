import 'package:flutter/material.dart';
class InputPhoneNumberScreen extends StatefulWidget {
  const InputPhoneNumberScreen({super.key});
  @override
  State<InputPhoneNumberScreen> createState() => _InputPhoneNumberScreenState();
}

class _InputPhoneNumberScreenState extends State<InputPhoneNumberScreen> {
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'SG';
  // PhoneNumber number = PhoneNumber(isoCode: 'SG');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Input phone number",
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 25),
            // InternationalPhoneNumberInput(
            //   onInputChanged: (PhoneNumber number) {
            //     print(number.phoneNumber);
            //   },
            //   onInputValidated: (bool value) {
            //     print(value);
            //   },
            //   selectorConfig: const SelectorConfig(
            //     selectorType: PhoneInputSelectorType.DIALOG,
            //   ),
            //   ignoreBlank: false,
            //   scrollPadding: const EdgeInsets.all(0),
            //   selectorButtonOnErrorPadding: 0,
            //   spaceBetweenSelectorAndTextField: 0,
            //   autoValidateMode: AutovalidateMode.disabled,
            //   selectorTextStyle: Theme.of(context).textTheme.titleLarge,
            //   textStyle: Theme.of(context).textTheme.titleLarge,
            //   initialValue: number,
            //   textFieldController: controller,
            //   formatInput: true,
            //   keyboardType:
            //       TextInputType.numberWithOptions(signed: true, decimal: true),
            //   inputBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   onSaved: (PhoneNumber number) {
            //     print('On Saved: $number');
            //   },
            // ),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement phone number validation and submission
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
