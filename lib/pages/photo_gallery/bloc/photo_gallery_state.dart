part of 'photo_gallery_bloc.dart';

@immutable
sealed class PhotoGalleryState {}

final class PhotoGalleryInitial extends PhotoGalleryState {}

final class PhotoGalleryLoading extends PhotoGalleryState {}

final class PhotoGalleryLoaded extends PhotoGalleryState {
  final List<String> photos;

  PhotoGalleryLoaded(this.photos);
}

final class PhotoGalleryError extends PhotoGalleryState {
  final String message;

  PhotoGalleryError(this.message);
}

final class PhotoGalleryEmpty extends PhotoGalleryState {}
