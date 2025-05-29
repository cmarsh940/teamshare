import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'photo_gallery_event.dart';
part 'photo_gallery_state.dart';

class PhotoGalleryBloc extends Bloc<PhotoGalleryEvent, PhotoGalleryState> {
  PhotoGalleryBloc() : super(PhotoGalleryInitial()) {
    on<LoadPhotoGallery>(_mapLoadPhotoGalleryToState);
  }

  _mapLoadPhotoGalleryToState(
    LoadPhotoGallery event,
    Emitter<PhotoGalleryState> emit,
  ) async {
    emit(PhotoGalleryLoading());

    // Simulating a network call with a delay
    await Future.delayed(const Duration(seconds: 2), () {
      // Dummy data
      emit(PhotoGalleryLoaded(event.teamId));
    });
  }
}
