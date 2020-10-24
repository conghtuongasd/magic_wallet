import 'package:etherwallet/features/transfer/domain/bloc/transfer_bloc.dart';
import 'package:etherwallet/features/transfer/domain/bloc/transfer_state.dart';
import 'package:etherwallet/widgets/form/paper_form.dart';
import 'package:etherwallet/widgets/form/paper_input.dart';
import 'package:etherwallet/widgets/form/paper_validation_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferForm extends StatefulWidget {
  TransferForm({
    this.address,
    @required this.onSubmit,
  });

  final String address;
  final void Function(String address, String amount) onSubmit;

  @override
  _TransferFormState createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  TextEditingController toController;
  TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    toController = TextEditingController(text: widget.address ?? '');
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    toController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: PaperForm(
            padding: 30,
            actionButtons: <Widget>[
              RaisedButton(
                child: const Text('Transfer now'),
                onPressed: () {
                  this.widget.onSubmit(
                        toController.value.text,
                        amountController.value.text,
                      );
                },
              )
            ],
            children: <Widget>[
              BlocBuilder<TransferBloc, TransferCoinState>(
                  builder: (context, state) {
                var hasError = false;
                List<String> errorList = [];
                if (state is TransferStateUpdated &&
                    state.walletTransfer.errors.length > 0) {
                  hasError = true;
                  errorList = state.walletTransfer.errors.toList();
                }
                return Visibility(
                    visible: hasError,
                    child: PaperValidationSummary(errorList));
              }),
              PaperInput(
                controller: toController,
                labelText: 'To',
                hintText: 'Type the destination address',
              ),
              PaperInput(
                controller: amountController,
                labelText: 'Amount',
                hintText: 'And amount',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
