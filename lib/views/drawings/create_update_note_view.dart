import 'package:flutter/material.dart';

class CreateUpdateDrawingView extends StatefulWidget {
  const CreateUpdateDrawingView({super.key});

  @override
  State<CreateUpdateDrawingView> createState() =>
      _CreateUpdateDrawingViewState();
}

class _CreateUpdateDrawingViewState extends State<CreateUpdateDrawingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Drawing'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 36.0,
              vertical: 48.0,
            ),
            child: Center(
              child: Text('Drawing'),
            ),
          ),
        ),
      ),
    );
  }
}
