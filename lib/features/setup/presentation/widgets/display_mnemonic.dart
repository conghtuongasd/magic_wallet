import 'package:etherwallet/widgets/copyButton/copy_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayMnemonic extends StatelessWidget {
  DisplayMnemonic({this.mnemonic, this.onNext});

  final String mnemonic;
  final Function onNext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "Get a piece of papper, write down your seed phrase and keep it safe. This is the only way to recover your funds.",
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.all(25),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all()),
                child: Text(
                  this.mnemonic,
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CopyButton(
                    text: const Text('Copy'),
                    value: this.mnemonic,
                  ),
                  RaisedButton(
                    child: const Text('Next'),
                    onPressed: this.onNext,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
