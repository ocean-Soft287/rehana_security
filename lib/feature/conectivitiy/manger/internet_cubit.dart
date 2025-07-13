import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'internet_state.dart';
class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? _subscription;
  bool _isManuallyDisconnected = false;

  InternetBloc() : super(InternetInitial()) {
    on<InternetChecked>((event, emit) {
      if (_isManuallyDisconnected) {
        emit(InternetDisconnectedState());
      } else {
        emit(state);
      }
    });

    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!_isManuallyDisconnected) {
        if (results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.mobile)) {
          add(InternetConnected());
        } else {
          add(InternetDisconnected());
        }
      }
    });

    on<InternetConnected>((event, emit) => emit(InternetConnectedState()));
    on<InternetDisconnected>((event, emit) => emit(InternetDisconnectedState()));

    on<InternetManuallyDisconnected>((event, emit) {
      _isManuallyDisconnected = !_isManuallyDisconnected;
      emit(_isManuallyDisconnected ? InternetDisconnectedState() : InternetConnectedState());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
abstract class InternetEvent {}

class InternetChecked extends InternetEvent {}

class InternetConnected extends InternetEvent {}

class InternetDisconnected extends InternetEvent {}

class InternetManuallyDisconnected extends InternetEvent {} // تعطيل يدوي
