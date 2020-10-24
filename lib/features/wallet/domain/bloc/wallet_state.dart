import 'package:equatable/equatable.dart';
import 'package:etherwallet/features/wallet/data/models/wallet.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletStateUpdated extends WalletState {
  final Wallet wallet;
  WalletStateUpdated({this.wallet});

  WalletStateUpdated copyWith({Wallet wallet}) {
    return WalletStateUpdated(wallet: wallet ?? this.wallet);
  }

  @override
  List<Object> get props => [wallet];
}
