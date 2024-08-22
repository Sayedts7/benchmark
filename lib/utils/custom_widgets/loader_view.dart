import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/provider/loader_view_provider.dart';

class LoaderView extends StatelessWidget {
  const LoaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderViewProvider>(
      builder: (context, p, child) => (p.showLoader)
          ? Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black26,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadiusDirectional.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
      )
          : Container(),
    );
  }
}
