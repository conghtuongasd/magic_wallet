import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialiseWallet extends WalletEvent {
  InitialiseWallet(this.address, this.privateKey);
  final String address;
  final String privateKey;
}

class UpdateBalance extends WalletEvent {
  UpdateBalance(this.address);
  final String address;
}

class UpdatingBalance extends WalletEvent {}
