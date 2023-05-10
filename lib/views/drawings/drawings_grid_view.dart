import 'package:flutter/material.dart';
import 'package:frozennotes/services/cloud/cloud_drawing.dart';

typedef DrawingCallback = void Function(CloudDrawing drawing);

class DrawingsGridView extends StatelessWidget {
  final Iterable<CloudDrawing> drawings;
  final DrawingCallback onTap;

  const DrawingsGridView({
    super.key,
    required this.drawings,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: drawings.length,
      itemBuilder: (context, index) {
        final drawing = drawings.elementAt(index);
        return GestureDetector(
          onTap: () {
            onTap(drawing);
          },
          child: const GridTile(
            header: Text('Drawing'),
            child: Icon(
              Icons.photo,
              size: 100,
            ),
          ),
        );
      },
    );
  }
}
