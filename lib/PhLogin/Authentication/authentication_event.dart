import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'App Started';
}

class LoggedIn extends AuthenticationEvent {
  final String token;
  LoggedIn({@required this.token}) : super([token]);
  @override
  String toString() => 'LoggedIn {token :$token}';
  @override
  List<Object> get props => [token];
}

class LoggedInButNotRegisterd extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'Logged Out';
  @override
  List<Object> get props => [];
}

class IsOldUser extends AuthenticationEvent {
  final String token;
  IsOldUser({this.token}) : super([token]);
  @override
  List<Object> get props => [token];
}
