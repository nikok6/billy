/* Create a button that does:
  Takes an input of 1 or 2
  1 means background is dark grey
  2 means background is green
  Takes an input of Icon to show
  Takes an input of text to show */

import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  
  const ReusableButton({Key? key, required this.onPressed, required this.text, required this.styleId}) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final int styleId;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.black,
        // fixedSize: Size(styleId == 1 ? 75 : 106, 30),
        backgroundColor: styleId == 1 ? Theme.of(context).colorScheme.primary:Theme.of(context).colorScheme.onSurfaceVariant,
        foregroundColor: styleId == 1 ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
        textStyle: styleId == 1 ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.labelMedium ,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}


