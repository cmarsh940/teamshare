part of 'photo_gallery_bloc.dart';

@immutable
sealed class PhotoGalleryEvent {}

class LoadPhotoGallery extends PhotoGalleryEvent {
  final String teamId;

  LoadPhotoGallery(this.teamId);
}
