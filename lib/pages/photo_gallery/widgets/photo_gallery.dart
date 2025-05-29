import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/photo_gallery/bloc/photo_gallery_bloc.dart';

class PhotoGallery extends StatefulWidget {
  final String teamId;

  const PhotoGallery({super.key, required this.teamId});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  late PhotoGalleryBloc _photoGalleryBloc;

  @override
  void initState() {
    super.initState();
    _photoGalleryBloc = BlocProvider.of<PhotoGalleryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoGalleryBloc, PhotoGalleryState>(
      builder: (context, state) {
        if (state is PhotoGalleryInitial) {
          _photoGalleryBloc.add(LoadPhotoGallery(widget.teamId));
        }
        if (state is PhotoGalleryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PhotoGalleryLoaded) {
          return Placeholder(
            child: Text('Photo Gallery for team ${widget.teamId}'),
          );
        }
        return const Center(
          child: Text(
            'No Members Available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _photoGalleryBloc.close();
    super.dispose();
  }
}
