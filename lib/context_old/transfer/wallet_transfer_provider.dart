import 'package:etherwallet/context_old/transfer/wallet_transfer_handler.dart';
import 'package:etherwallet/context_old/transfer/wallet_transfer_state.dart';
import 'package:etherwallet/features/transfer/data/models/wallet_transfer.dart';
import 'package:etherwallet/services/configuration_service.dart';
import 'package:etherwallet/services/contract_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import '../hook_provider.dart';

class WalletTransferProvider
    extends ContextProviderWidget<WalletTransferHandler> {
  WalletTransferProvider(
      {Widget child, HookWidgetBuilder<WalletTransferHandler> builder})
      : super(child: child, builder: builder);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<WalletTransfer, WalletTransferAction>(reducer,
        initialState: WalletTransfer());

    final contractService = GetIt.instance<ContractService>();
    final configurationService = GetIt.instance<ConfigurationService>();
    final handler = useMemoized(
      () => WalletTransferHandler(store, contractService, configurationService),
      [contractService, store],
    );

    return provide(context, handler);
  }
}

WalletTransferHandler useWalletTransfer(BuildContext context) {
  var handler = GetIt.instance<WalletTransferHandler>();

  return handler;
}
