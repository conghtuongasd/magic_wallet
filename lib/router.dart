import 'package:etherwallet/blocs/setup/setup_bloc.dart';
import 'package:etherwallet/qrcode_reader_page.dart';
import 'package:etherwallet/service/address_service.dart';
import 'package:etherwallet/service/configuration_service.dart';
import 'package:etherwallet/service/contract_service.dart';
import 'package:etherwallet/wallet_create_page.dart';
import 'package:etherwallet/wallet_import_page.dart';
import 'package:etherwallet/wallet_main_page.dart';
import 'package:etherwallet/wallet_transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'blocs/wallet/wallet_bloc.dart';
import 'context/transfer/wallet_transfer_provider.dart';
import 'intro_page.dart';

Map<String, WidgetBuilder> getRoutes(context) {
  return {
    '/': (BuildContext context) {
      var configurationService = GetIt.instance<ConfigurationService>();
      if (configurationService.didSetupWallet())
        return BlocProvider<WalletBloc>(
            create: (BuildContext context) => WalletBloc(
                GetIt.instance<AddressService>(),
                configurationService,
                GetIt.instance<ContractService>())
              ..initialise(),
            child: WalletMainPage("Your wallet"));
      return IntroPage();
    },
    '/create': (BuildContext context) => BlocProvider<WalletSetupBloc>(
        create: (BuildContext context) =>
            WalletSetupBloc(GetIt.instance<AddressService>())
              ..generateMnemonic(),
        child: WalletCreatePage("Create wallet")),
    '/import': (BuildContext context) => BlocProvider<WalletSetupBloc>(
        create: (BuildContext context) =>
            WalletSetupBloc(GetIt.instance<AddressService>()),
        child: WalletImportPage("Import wallet")),
    '/transfer': (BuildContext context) => WalletTransferProvider(
          builder: (context, store) {
            return WalletTransferPage(title: "Send Tokens");
          },
        ),
    '/qrcode_reader': (BuildContext context) => QRCodeReaderPage(
          title: "Scan QRCode",
          onScanned: ModalRoute.of(context).settings.arguments,
        )
  };
}
