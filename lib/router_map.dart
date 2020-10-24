import 'package:etherwallet/features/setup/domain/bloc/setup_bloc.dart';
import 'package:etherwallet/features/transfer/domain/bloc/transfer_bloc.dart';
import 'package:etherwallet/features/qrcode/presentation/screens/qrcode_reader_screen.dart';
import 'package:etherwallet/features/setup/presentation/screens/wallet_create_screen.dart';
import 'package:etherwallet/features/setup/presentation/screens/wallet_import_screen.dart';
import 'package:etherwallet/features/wallet/presentation/screens/wallet_main_screen.dart';
import 'package:etherwallet/features/transfer/presentation/screens/wallet_transfer_screen.dart';
import 'package:etherwallet/routes.dart';
import 'package:etherwallet/services/address_service.dart';
import 'package:etherwallet/services/configuration_service.dart';
import 'package:etherwallet/services/contract_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'features/intro/presentation/screens/intro_screen.dart';

Map<String, WidgetBuilder> getRouterMap(context) {
  return {
    Routes.WalletMainScreen: (BuildContext context) {
      var configurationService = GetIt.instance<ConfigurationService>();
      if (configurationService.didSetupWallet())
        return WalletMainScreen("Magic Wallet");
      return IntroScreen();
    },
    Routes.WalletCreateScreen: (BuildContext context) =>
        BlocProvider<WalletSetupBloc>(
            create: (BuildContext context) =>
                WalletSetupBloc(GetIt.instance<AddressService>())
                  ..generateMnemonic(),
            child: WalletCreateScreen("Create wallet")),
    Routes.WalletImportScreen: (BuildContext context) =>
        BlocProvider<WalletSetupBloc>(
            create: (BuildContext context) =>
                WalletSetupBloc(GetIt.instance<AddressService>()),
            child: WalletImportScreen("Import wallet")),
    Routes.WalletTransferScreen: (BuildContext context) =>
        BlocProvider<TransferBloc>(
          create: (BuildContext context) => TransferBloc(
              GetIt.instance<ConfigurationService>(),
              GetIt.instance<ContractService>()),
          child: WalletTransferScreen(title: "Send Tokens"),
        ),
    Routes.QRCodeReaderScreen: (BuildContext context) => QRCodeReaderScreen(
          title: "Scan QRCode",
          onScanned: ModalRoute.of(context).settings.arguments,
        )
  };
}
