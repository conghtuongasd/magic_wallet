import 'package:etherwallet/routes.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Create new wallet"),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.WalletCreateScreen);
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: OutlineButton(
                child: Text("Import wallet"),
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.WalletImportScreen);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
