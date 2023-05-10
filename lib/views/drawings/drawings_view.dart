import 'package:flutter/material.dart';
import 'package:frozennotes/services/auth/auth_service.dart';
import 'package:frozennotes/services/cloud/cloud_drawing.dart';
import 'package:frozennotes/services/cloud/cloud_drawing_storage_service.dart';
import 'package:frozennotes/utils/constants/routes.dart';
import 'package:frozennotes/views/drawings/drawings_grid_view.dart';

class DrawingsView extends StatefulWidget {
  const DrawingsView({super.key});

  @override
  State<DrawingsView> createState() => _DrawingsViewState();
}

class _DrawingsViewState extends State<DrawingsView> {
  // current user id
  String get userId => AuthService.firebase().currentUser!.id;

  late final CloudDrawingStorageService _drawingsService;

  @override
  void initState() {
    _drawingsService = CloudDrawingStorageService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Drawings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _buildDrawingsGrid(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateDrawingRoute);
        },
        backgroundColor: Colors.lightBlue.shade200,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawingsGrid() {
    return StreamBuilder(
      stream: _drawingsService.allDrawings(ownerUserId: userId),
      builder: (
        context,
        snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allDrawings = snapshot.data as Iterable<CloudDrawing>;
              if (allDrawings.isEmpty) {
                return Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      children: const [
                        Text(
                          'Ready to draw or take note of something?',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Create your first drawing now!',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                // grid of all drawings
                return DrawingsGridView(
                  drawings: allDrawings,
                  // tap on drawing
                  onTap: (drawing) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateDrawingRoute,
                      arguments: drawing,
                    );
                  },
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
