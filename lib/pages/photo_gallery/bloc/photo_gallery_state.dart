part of 'photo_gallery_bloc.dart';

@immutable
sealed class PhotoGalleryState {}

final class PhotoGalleryInitial extends PhotoGalleryState {}

final class PhotoGalleryLoading extends PhotoGalleryState {}

final class PhotoGalleryLoaded extends PhotoGalleryState {
  final String teamId;

  PhotoGalleryLoaded(this.teamId);
}
