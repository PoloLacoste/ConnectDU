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

void showErrorDialog(BuildContext context, String error, {Function onTap}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Error",
          style: TextStyle(
            color: Colors.red
          ),
        ),
        content: Text(
          error,
          style: TextStyle(
            color: Colors.red
          ),
        ),
        actions: [
          Center(
            child: FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
                if(onTap != null) {
                  onTap();
                }
              },
            ),
          )
        ],
      );
    }
  );
}