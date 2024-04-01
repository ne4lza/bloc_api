import 'package:bloc_api/blocs/app_events.dart';
import 'package:bloc_api/blocs/app_states.dart';
import 'package:bloc_api/repos/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent,UserState>{
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserLoadingState()){
    on<LoadUserEvent>((event,emit) async{
      emit(UserLoadingState());
      print("yeniden yükleniyor..");
      try{
        final users = await _userRepository.getUsers();
        emit(UserLoadedState(users));
      }catch (e){
        emit(UserErrorState(e.toString()));
      }
    });
  }
}