import 'package:flutter/material.dart';

class FinishButton extends StatelessWidget {
  final VoidCallback _onPressed;

  FinishButton({Key? key, required VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(30.0),
      // ),
      onPressed: _onPressed,
      child: const Text('Finished'),
    );
  }
}