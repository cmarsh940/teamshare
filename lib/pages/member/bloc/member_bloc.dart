import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc() : super(MemberInitial()) {
    on<LoadMembers>(_mapLoadMembersToState);
  }

  _mapLoadMembersToState(LoadMembers event, Emitter<MemberState> emit) async {
    // Here you would typically fetch the members from a repository or service
    // For now, we will just emit a loading state and then a loaded state with dummy data

    emit(MembersLoading());

    // Simulating a network call with a delay
    await Future.delayed(Duration(seconds: 2), () {
      // Dummy data
      final members = ['Member 1', 'Member 2', 'Member 3'];
      emit(MembersLoaded(members));
    });
  }
}
