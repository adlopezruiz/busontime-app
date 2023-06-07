part of 'bus_bloc.dart';

abstract class BusState extends Equatable {
  const BusState();
  
  @override
  List<Object> get props => [];
}

class BusInitial extends BusState {}
