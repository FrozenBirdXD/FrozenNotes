import 'package:flutter/material.dart';

class DrawableView extends StatefulWidget {
  const DrawableView({super.key});

  @override
  State<DrawableView> createState() => _DrawableViewState();
}

class _DrawableViewState extends State<DrawableView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Drawable Notes'),
      ),
      body: const Text('Drawable View'),
    );
  }
}
