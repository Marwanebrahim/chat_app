import 'package:equatable/equatable.dart';

sealed class SearchEvent extends Equatable {}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;
  SearchQueryChangedEvent(this.query);
  @override
  List<Object?> get props => [query];
}
