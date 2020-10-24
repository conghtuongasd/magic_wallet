import 'package:equatable/equatable.dart';

abstract class TransferCoinEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TransferCoin extends TransferCoinEvent {
  TransferCoin(this.to, this.amount);
  final String to;
  final String amount;
}

class TransferCoinError extends TransferCoinEvent {
  TransferCoinError(this.errorMsg);
  final String errorMsg;
}
