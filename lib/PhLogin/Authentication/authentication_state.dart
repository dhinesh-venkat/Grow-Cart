import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class Uninitilized extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class AuthenticatedButNotRegistered extends AuthenticationState {}

class UnAuthenticated extends AuthenticationState {}

class Loading extends AuthenticationState {}

class IsOldUserRegisteredState extends AuthenticationState {}

class IsOldUserNotRegisteredState extends AuthenticationState {}
