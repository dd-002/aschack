import 'package:flutter/material.dart';

class DelButton extends StatelessWidget {
  final Function()? onTap;

  const DelButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 0, 0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Verified",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
