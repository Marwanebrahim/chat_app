import 'package:chat_app/models/user_model.dart';
import 'package:equatable/equatable.dart';

sealed class SearchState extends Equatable {}

class SearchInitialState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoadingState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoadedState extends SearchState {
  final List<UserModel> users;
  SearchLoadedState({required this.users});
  @override
  List<Object?> get props => [users];
}

class SearchErrorState extends SearchState {
  final String errorMessage;
  SearchErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
