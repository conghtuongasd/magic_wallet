import 'dart:async';
import 'dart:math';
import 'package:etherwallet/features/transfer/data/models/wallet_transfer.dart';
import 'package:etherwallet/features/transfer/domain/bloc/transfer_event.dart';
import 'package:etherwallet/features/transfer/domain/bloc/transfer_state.dart';
import 'package:etherwallet/services/configuration_service.dart';
import 'package:etherwallet/services/contract_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/credentials.dart';

class TransferBloc extends Bloc<TransferCoinEvent, TransferCoinState> {
  final ConfigurationService _configurationService;
  final ContractService _contractService;

  var transferCompleter = Completer<bool>();

  TransferBloc(this._configurationService, this._contractService)
      : super(TransferStateUpdated(walletTransfer: WalletTransfer()));

  Future<bool> transfer(String to, String amount) async {
    add(TransferCoin(to, amount));
    return transferCompleter.future;
  }

  WalletTransfer _changeToErrorState(WalletTransfer curState, String errorMsg) {
    return curState.rebuild((b) => b
      ..status = WalletTransferStatus.none
      ..errors.add(errorMsg)
      ..loading = false);
  }

  @override
  Stream<TransferCoinState> mapEventToState(event) async* {
    final currentState = state;

    if (event is TransferCoin) {
      if (currentState is TransferStateUpdated) {
        yield TransferStateUpdated(
            walletTransfer: currentState.walletTransfer.rebuild((b) => b
              ..errors.clear()
              ..status = WalletTransferStatus.started
              ..loading = true));
        var privateKey = _configurationService.getPrivateKey();

        try {
          await _contractService.send(
            privateKey,
            EthereumAddress.fromHex(event.to),
            BigInt.from(double.parse(event.amount) * pow(10, 18)),
            onTransfer: (from, to, value) {
              transferCompleter.complete(true);
            },
            onError: (ex) {
              add(TransferCoinError(ex.toString()));
              transferCompleter.complete(false);
            },
          );
        } catch (ex) {
          yield TransferStateUpdated(
              walletTransfer: _changeToErrorState(
                  currentState.walletTransfer, ex.toString()));
          transferCompleter.complete(false);
        }
      }
    } else if (event is TransferCoinError) {
      if (currentState is TransferStateUpdated)
        yield TransferStateUpdated(
            walletTransfer: _changeToErrorState(
                currentState.walletTransfer, event.errorMsg));
    }
  }
}
