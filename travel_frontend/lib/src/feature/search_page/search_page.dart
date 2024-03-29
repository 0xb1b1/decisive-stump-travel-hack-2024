import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make the scaffold background transparent
          appBar: AppBar(
            title: const Text('NEW USER'),
            backgroundColor: Colors.transparent, // Make the app bar background transparent
            elevation: 0, // Remove app bar elevation
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Your body content here
              ],
            ),
          ),
        ),
      ],
    );;
  }
}
