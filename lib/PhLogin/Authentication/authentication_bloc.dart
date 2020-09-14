import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../phlogin.dart';
import 'bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await _userRepository.getUser() != null;
      if (hasToken == true) {
        final bool valid = await _userRepository.alreadyRegistered();
        if (valid) {
          yield Authenticated();
        } else if (valid == false) {
          yield AuthenticatedButNotRegistered();
        }
      } else {
        yield UnAuthenticated();
      }
    }
    if (event is LoggedInButNotRegisterd) {
      yield AuthenticatedButNotRegistered();
    }
    if (event is LoggedIn) {
      yield Loading();
      yield Authenticated();
    }
    if (event is LoggedOut) {
      yield Loading();
      yield UnAuthenticated();
    }
    if (event is IsOldUser) {
      final bool valid = await _userRepository.alreadyRegistered();
      if (valid == false) {
        yield IsOldUserNotRegisteredState();
      } else if (valid == true) {
        yield IsOldUserRegisteredState();
      }
    }
  }
}
