import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'LoadingIndicator.dart';


class ProgressDialogBuilder {
  ProgressDialog? _progressDialog;

  ProgressDialogBuilder(this._dialogContext);

  final BuildContext _dialogContext;

  void initiateLDialog(String text) {
    _progressDialog =  ProgressDialog(_dialogContext,
        isDismissible: false, customBody:  LoadingIndicator(title: text));

  }
  ProgressDialog? getDialog()
  {
    return _progressDialog;
  }

  void showLoadingDialog() {
  //  if(_progressDialog?.isShowing()==false)
    _progressDialog?.show();
  }

  void hideOpenDialog() {
   if(_progressDialog?.isShowing()==true)
    _progressDialog?.hide();
  }
}
