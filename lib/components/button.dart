import 'package:flutter/material.dart';

class myButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const myButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        // The background color of the button
        backgroundColor: Theme.of(context).colorScheme.primary,
        // The shape and border radius of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // Padding inside the button
        padding: const EdgeInsets.all(20),
        // Text style for the button's child
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}