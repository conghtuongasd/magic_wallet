import 'package:equatable/equatable.dart';
import 'package:etherwallet/features/transfer/data/models/wallet_transfer.dart';

abstract class TransferCoinState extends Equatable {
  const TransferCoinState();

  @override
  List<Object> get props => [];
}

class TransferStateUpdated extends TransferCoinState {
  final WalletTransfer walletTransfer;
  TransferStateUpdated({this.walletTransfer});

  TransferStateUpdated copyWith({WalletTransfer wallet}) {
    return TransferStateUpdated(walletTransfer: wallet ?? this.walletTransfer);
  }

  @override
  List<Object> get props => [walletTransfer];
}
