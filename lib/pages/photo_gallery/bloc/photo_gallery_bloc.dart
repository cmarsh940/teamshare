import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/team_repository.dart';

part 'photo_gallery_event.dart';
part 'photo_gallery_state.dart';

class PhotoGalleryBloc extends Bloc<PhotoGalleryEvent, PhotoGalleryState> {
  TeamRepository teamRepository = GetIt.I<TeamRepository>();
  PhotoGalleryBloc() : super(PhotoGalleryInitial()) {
    on<LoadPhotoGallery>(_mapLoadPhotoGalleryToState);
  }

  _mapLoadPhotoGalleryToState(
    LoadPhotoGallery event,
    Emitter<PhotoGalleryState> emit,
  ) async {
    emit(PhotoGalleryLoading());

    try {
      final photos = await teamRepository.getTeamPhotos(event.teamId);
      if (photos.isEmpty) {
        emit(PhotoGalleryEmpty());
      } else {
        emit(PhotoGalleryLoaded(photos));
      }
    } catch (error) {
      emit(PhotoGalleryError(error.toString()));
    }
  }

  _mapAddPhotoToGalleryToState(
    AddPhotoToGallery event,
    Emitter<PhotoGalleryState> emit,
  ) async {
    try {
      await teamRepository.addPhotoToGallery(event.teamId, event.photoUrl);
      final photos = await teamRepository.getTeamPhotos(event.teamId);
      emit(PhotoGalleryLoaded(photos));
    } catch (error) {
      emit(PhotoGalleryError(error.toString()));
    }
  }
}
