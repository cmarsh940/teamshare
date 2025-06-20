import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/photo_gallery/bloc/photo_gallery_bloc.dart';
import 'package:teamshare/pages/photo_gallery/widgets/photo_gallery.dart';

class PhotoGalleryPage extends StatelessWidget {
  final String teamId;

  const PhotoGalleryPage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<PhotoGalleryBloc>(
          create: (context) => PhotoGalleryBloc(),
          child: PhotoGallery(teamId: teamId),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for adding a new photo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Photo functionality not implemented'),
            ),
          );
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
