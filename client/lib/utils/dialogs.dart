import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {bool canPop = true, Function willPop})
{
	showDialog(
		context: context,
		builder: (_) => WillPopScope(
			onWillPop: () async {
				if(willPop != null)
				{
					willPop();
				}
				return canPop;
			},
			child: Material(
				type: MaterialType.transparency,
				child: Center(
					child: CircularProgressIndicator(),
				),
			),
		)
	);
}