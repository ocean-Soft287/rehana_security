part of 'internet_cubit.dart';

abstract class InternetState {}

class InternetInitial extends InternetState {}

class InternetConnectedState extends InternetState {}

class InternetDisconnectedState extends InternetState {} // الحالة الموحدة للانفصال


